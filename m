Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAM0nfQj029511
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 19:49:41 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAM0nRBY023486
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 19:49:27 -0500
Received: by wf-out-1314.google.com with SMTP id 25so1214939wfc.6
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 16:49:26 -0800 (PST)
Message-ID: <d7e40be30811211649s79047226ne2f79a4dced9c7c7@mail.gmail.com>
Date: Sat, 22 Nov 2008 11:49:25 +1100
From: "Ben Klein" <shacklein@gmail.com>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>,
	V4L <video4linux-list@redhat.com>
In-Reply-To: <412bdbff0811211615r4ed250f8q12b28eda3a352778@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <412bdbff0811161506j3566ad4dsae09a3e1d7559e3@mail.gmail.com>
	<alpine.DEB.1.10.0811172119370.855@bakacsin.ki.iif.hu>
	<412bdbff0811171254s5e732ce4p839168f22d3a387@mail.gmail.com>
	<alpine.DEB.1.10.0811192133380.32523@bakacsin.ki.iif.hu>
	<412bdbff0811191305y320d6620vfe28c0577709ea66@mail.gmail.com>
	<d7e40be30811211600u354bf1ebg57567ebd3cd375a@mail.gmail.com>
	<412bdbff0811211615r4ed250f8q12b28eda3a352778@mail.gmail.com>
Cc: 
Subject: Re: [video4linux] Attention em28xx users
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

2008/11/22 Devin Heitmueller <devin.heitmueller@gmail.com>:
> On Fri, Nov 21, 2008 at 7:00 PM, Ben Klein <shacklein@gmail.com> wrote:
>>
>> 2008/11/20 Devin Heitmueller <devin.heitmueller@gmail.com>
>>>
>>> Playing with the "card=" argument is probably not such a good idea.
>>> I should consider taking that functionality out, since setting to the
>>> wrong card number can damage the device (by setting the wrong GPIOs).
>>
>> What about us folk who currently can't get em28xx working without the
>> "card=" option? With no card= option, my "Tevion High Speed DVD Maker"
>> device (eb1a:2861) is detected but reports no inputs (the inputs should be
>> S-Video and Composite). dmesg snippet:
-- snip --
>> So far, the only card= values I've found also report a TV tuner (10, 13, 38,
>> 39, 58), but I haven't tested every single value.
>>
>
> I can add a device profile so you don't need to specify a "card="
> entry in the future.  Please send me a link to the product page if
> possible and I will look at it this weekend.  If there isn't a page
> you can refer me to, send me as much information about the device that
> you can (what inputs are available for it [composite, tuner, s-video]
> and whether it has a remote control).

I don't think it'd be easy if possible at all to find technical
details about it, but this is the device:
http://www.unisupport.net/lang/au/dvd-grabber.htm

Audio is usb-audio, inputs are S-Video and Composite. No TV tuner (or
at least nowhere to stick an antenna) and no remote control.

Thanks for your help :) If you need more information (like lsusb
output), just let me know

> Cheers,
>
> Devin

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
