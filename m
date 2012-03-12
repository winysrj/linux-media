Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab2CLK2X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Mar 2012 06:28:23 -0400
Message-ID: <4F5DCFB2.7090108@redhat.com>
Date: Mon, 12 Mar 2012 07:28:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH] [media] dib0700: Fix memory leak during initialization
References: <20120212111911.32f4c390@endymion.delvare> <4F589630.5020008@redhat.com> <20120312110450.6f052af0@endymion.delvare>
In-Reply-To: <20120312110450.6f052af0@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 12-03-2012 07:04, Jean Delvare escreveu:
> Hi Mauro,
> 
> Thanks for your reply.
> 
> On Thu, 08 Mar 2012 08:21:20 -0300, Mauro Carvalho Chehab wrote:
>> Em 12-02-2012 08:19, Jean Delvare escreveu:
>>> Reported by kmemleak.
>>>
>>> Signed-off-by: Jean Delvare <khali@linux-fr.org>
>>> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
>>> Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
>>> ---
>>> I am not familiar with the usb API, are we also supposed to call
>>> usb_kill_urb() in the error case maybe?
>>>
>>>  drivers/media/dvb/dvb-usb/dib0700_core.c |    2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> --- linux-3.3-rc3.orig/drivers/media/dvb/dvb-usb/dib0700_core.c	2012-01-20 14:06:38.000000000 +0100
>>> +++ linux-3.3-rc3/drivers/media/dvb/dvb-usb/dib0700_core.c	2012-02-12 00:32:19.005334036 +0100
>>> @@ -787,6 +787,8 @@ int dib0700_rc_setup(struct dvb_usb_devi
>>>  	if (ret)
>>>  		err("rc submit urb failed\n");
>>>  
>>> +	usb_free_urb(purb);
>>> +
>>>  	return ret;
>>>  }
>>
>> This patch doesn't sound right on my eyes, as you're freeing
>> an URB that you've just submitted _before_ having it handled
>> by the dib0700_rc_urb_completion() callback.
> 
> Oops, you're totally right. I don't know a thing about USB as you can
> see :(

It takes some time to get this logic ;)

> 
>> Btw, it seems that there's a bug at the fist if there:
>>
>> static void dib0700_rc_urb_completion(struct urb *purb)
>> {
>> 	struct dvb_usb_device *d = purb->context;
>> 	struct dib0700_rc_response *poll_reply;
>> 	u32 uninitialized_var(keycode);
>> 	u8 toggle;
>>
>> 	deb_info("%s()\n", __func__);
>> 	if (d == NULL)
>> 		return;
>>
>> 	if (d->rc_dev == NULL) {
>> 		/* This will occur if disable_rc_polling=1 */
>> 		usb_free_urb(purb);
>> 		return;
>> 	}
>>
>> ...
>>
>> it should be, instead:
>>
>> 	if (!d || !d->rc_dev) {
>> 		/* This will occur if disable_rc_polling=1 */
>> 		usb_free_urb(purb);
>> 		return;
>> 	}	
> 
> "!d" can't actually happen, so it doesn't matter. d is passed by
> dib0700_rc_setup() when calling usb_fill_bulk_urb(), and
> dib0700_rc_setup() starts with dereferencing d, if it was NULL we'd
> crash right away. Hence d is never NULL in dib0700_rc_urb_completion().
> 
> So this "if (d == NULL)" is just paranoia and might as well be removed.

Ok. Feel free to remove it on your patch.

> 
>> That's said, clearly there's no condition to stop the DVB IR
>> handling.
> 
> Indeed, as I read the code, unless disable_rc_polling=1 or a fatal
> error occurs, dib0700_rc_urb_completion will loop over and over
> endlessly. I guess it's what "RC polling" is all about. No surprise why
> my DVB-T card sucks so much power...

This code should not poll anymore, at least with a v1.2 firmware. 

The URB code will run only when the URB arrives. The URB will only arrive
when some key is pressed. At key press, the URB handling code will re-trigger
the URB handler to be prepared for a next key.

> 
>> Probably, the right thing to do there is to add a function like:
>>
>> int dib0700_disconnect(...) 
>> {
>> 	usb_unlink_urb(urb);
>> 	usb_free_urb(urb);
>>
>> 	dvb_usb_device_exit(...);
>> }
>>
>> and use such function for the usb_driver disconnect handling: 
>>
>> static struct usb_driver dib0700_driver = {
>> 	.name       = "dvb_usb_dib0700",
>> 	.probe      = dib0700_probe,
>> 	.disconnect = dib0700_disconnect,
>> 	.id_table   = dib0700_usb_id_table,
>> };
> 
> This would avoid a memory leak on module removal, right?

Yes.

> Sure, we can do that, but what surprises me is that I don't remember
> removing the  module when kmemleak reported the leak to me. Oh well,
> kmemleak is pretty new, maybe that was a false positive after all.

It seems weird that kmemleak would warn about a leak before the
memory removal. There are several places during driver init where data
is alloced, and will only be freed at driver removal. The same happens
with device probe/disconnect.

> But is it OK to free the same URB twice?

Hmm... not sure. Maybe it will need some atomic var to point if the
URB is running or not, using it to detect if the IR URB handling is
running or not.

> Your code above does it
> unconditionally, while it may have been freed already
> (disable_rc_polling=1 or a fatal error occurred). As it seems that
> usb_unlink_urb() will call the completion callback with an error
> status, and dib0700_rc_urb_completion() will free the URB when that
> happens, I suppose it is sufficient to call usb_unlink_urb() in the
> diconnect function?

Yes, this should be enough, if usb_unlink_urb waits for the completion
calback to run (I think it waits).

Regards,
Mauro
