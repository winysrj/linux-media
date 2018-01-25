Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35292 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751224AbeAYVks (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 16:40:48 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v2] v4l: async: Protect against double notifier
 registrations
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
References: <1516146473-18234-1-git-send-email-kieran.bingham@ideasonboard.com>
 <CAMuHMdUsCMqSG5kci9FhAfwvgxgXo5xy=JRtiQbYdESsmVYvPw@mail.gmail.com>
Message-ID: <7f6c248e-6644-dafa-70e4-0839c31818fc@ideasonboard.com>
Date: Thu, 25 Jan 2018 21:40:43 +0000
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUsCMqSG5kci9FhAfwvgxgXo5xy=JRtiQbYdESsmVYvPw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------A500F309CA27E77D5F9407DA"
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------A500F309CA27E77D5F9407DA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi Geert,

Thanks for the review

On 17/01/18 08:00, Geert Uytterhoeven wrote:
> Hi Kieran,
> 
> On Wed, Jan 17, 2018 at 12:47 AM, Kieran Bingham
> <kieran.bingham@ideasonboard.com> wrote:
>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> It can be easy to attempt to register the same notifier twice
>> in mis-handled error cases such as working with -EPROBE_DEFER.
>>
>> This results in odd kernel crashes where the notifier_list becomes
>> corrupted due to adding the same entry twice.
>>
>> Protect against this so that a developer has some sense of the pending
>> failure, and use a WARN_ON to identify the fault.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> Thanks for your patch!
> 
> However, I have several comments:
>   1. Instead of walking notifier_list (O(n)), can't you just check if
>      notifier.list is part of a list or not (O(1))?

Not safely as far as I can see: (unless you know better)

Looks like I'd have to at least check something like the following:
  notifier->next != LIST_POISON1 && notifier->next != NULL &&
  notifier->prev != LIST_POISON2 && notifier->prev != NULL &&
  notifier->next != notifier->prev

Although - that doesn't count the possibility that the struct list_head in the
object being added is essentially un-initialised before being added to the list
- so it could technically contain any value ...

(Looking forward to being told I'm completely missing something obvious here...)


>   2. Isn't notifier usually (always?) allocated dynamically, so if will be a
>      different pointer after a previous -EPROBE_DEFER anyway?

Nope. The notifier can be part of the device context structure to reduce
allocations.



>   3. If you enable CONFIG_DEBUG_LIST, it should scream, too.

Aha - maybe that was my missing link. -E_NOT_ENOUGH_DEBUG_ENABLED.

Although I've just looked through the code that checks against a double entry.
It may have helped me find my bug in fact, but I think that would only fire if
the entry tried to add twice consecutively, which certainly wouldn't be
guaranteed if a driver returned with -EPROBE_DEFER.

So - I've just tested that if you have A B C and HEAD,

list_add(A, HEAD);
list_add(A, HEAD);
  // would fire in __list_add_valid as (new == prev || new == next)

However,

list_add(A, HEAD);
list_add(B, HEAD);
list_add(C, HEAD);
list_add(B, HEAD);

Will not catch this double-add-B in __list_add_valid(), and will generate an
infinitely looping list if you try to then walk it with list_for_each_entry()

(As demonstrated by the attached list-test.c module which I used to test this)

Oh what fun :D

--
Kieran


> 
>> --- a/drivers/media/v4l2-core/v4l2-async.c
>> +++ b/drivers/media/v4l2-core/v4l2-async.c
>> @@ -374,17 +374,26 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
>>         struct device *dev =
>>                 notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL;
>>         struct v4l2_async_subdev *asd;
>> +       struct v4l2_async_notifier *n;
>>         int ret;
>>         int i;
>>
>>         if (notifier->num_subdevs > V4L2_MAX_SUBDEVS)
>>                 return -EINVAL;
>>
>> +       mutex_lock(&list_lock);
>> +
>> +       /* Avoid re-registering a notifier. */
>> +       list_for_each_entry(n, &notifier_list, list) {
>> +               if (WARN_ON(n == notifier)) {
>> +                       ret = -EEXIST;
>> +                       goto err_unlock;
>> +               }
>> +       }
>> +
>>         INIT_LIST_HEAD(&notifier->waiting);
>>         INIT_LIST_HEAD(&notifier->done);
>>
>> -       mutex_lock(&list_lock);
>> -
>>         for (i = 0; i < notifier->num_subdevs; i++) {
>>                 asd = notifier->subdevs[i];
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 


--------------A500F309CA27E77D5F9407DA
Content-Type: text/x-csrc;
 name="list-test.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="list-test.c"

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/list.h>


struct item {
	struct list_head list;
	int i;
};

struct item items[5];

int __init helloworld_init(void)
{
	int a;
	struct list_head head;
	struct item * ob;
	bool catch_double_add =3D 1;

	INIT_LIST_HEAD(&head);

	printk("Hello World !\n");

	for (a =3D 0; a < 5; a++) {
		items[a].i =3D a;
		list_add(&items[a].list, &head);
	}

	for (a =3D 0; a < 5; a++)
		printk("Item[%d] =3D %d\n", a, items[a].i);

	list_for_each_entry(ob, &head, list) {
		printk("ob =3D %d\n", ob->i);
	}

	if (catch_double_add)
		list_add(&items[4].list, &head);
	else
		list_add(&items[2].list, &head);

	list_for_each_entry(ob, &head, list) {
		printk("ob =3D %d\n", ob->i);
	}

	return 0;
}

void __exit helloworld_exit(void)
{
	pr_info("Goodbye cruel world...\n");
}

module_init(helloworld_init);
module_exit(helloworld_exit);
MODULE_LICENSE("GPL");

--------------A500F309CA27E77D5F9407DA--
