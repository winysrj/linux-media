Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAK7gqYK008983
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 02:42:52 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAK7gfQj025635
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 02:42:41 -0500
Received: by rv-out-0506.google.com with SMTP id f6so356712rvb.51
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 23:42:41 -0800 (PST)
Message-ID: <208cbae30811192342s1175777q3a7fb831603b82da@mail.gmail.com>
Date: Thu, 20 Nov 2008 10:42:40 +0300
From: "Alexey Klimov" <klimov.linux@gmail.com>
To: "Douglas Schilling Landgraf" <dougsland@gmail.com>
In-Reply-To: <20081120013156.2157739c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227054955.2389.32.camel@tux.localhost>
	<20081120013156.2157739c@gmail.com>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 0/1] radio-mr800: fix unplug
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello, Douglas

On Thu, Nov 20, 2008 at 6:31 AM, Douglas Schilling Landgraf
<dougsland@gmail.com> wrote:
> Hello Alexey,
>
> On Wed, 19 Nov 2008 03:35:55 +0300
> Alexey Klimov <klimov.linux@gmail.com> wrote:
>
>> Hello, all
>>
>> This patch fix such thing. When you listening the radio with you
>> user-space application(kradio/gnomeradio/mplayer/etc) and suddenly you
>> unplug the device from usb port and then close application or change
>> frequency of the radio - a lot of oopses appear in dmesg. I also had
>> big problems with stability of kernel(different memory leaks,
>> lockings) in ~30% of cases when using mplayer trying to reproduce
>> this bug.
>
>> This thing happens with dsbr100 radio and radio-mr800. I told about
>> this thing to Douglas Schilling Landgraf and then he suggested right
>> decision for dsbr100. He told me that he get ideas of preventing this
>> bug from Tobias radio-si470x driver. Hopefully this bug didn't show
>> up in radio-si470x. Well, i used Douglas suggestion and code of
>> si470x and made this patch.
>>
>> Douglas said that he's going to create patch for dsbr100.
>
> humm, since you already fixed radio-mr800 and I'm working with other
> developers to improve em28xx... Are you interested to make a patch to
> fix dsbr100?
>
> Cheers,
> Douglas
>

Well, if you okay with that and if this patch (for mr800) is right - i
can make patch for dsbr100. Currently, i don't have access to this
device for a few days. So, if i don't post this patch to this list in
a week - please contact with me.


-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
