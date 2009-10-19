Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.216.179]:49637 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627AbZJSPQl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 11:16:41 -0400
Received: by pxi9 with SMTP id 9so1177810pxi.4
        for <linux-media@vger.kernel.org>; Mon, 19 Oct 2009 08:16:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <93004.23373.qm@web31503.mail.mud.yahoo.com>
References: <93004.23373.qm@web31503.mail.mud.yahoo.com>
Date: Mon, 19 Oct 2009 19:10:54 +0400
Message-ID: <208cbae30910190810k71f0860ei45c1aec1694095b3@mail.gmail.com>
Subject: Re: Gadmei 380 on kernel 2.6.28.4
From: Alexey Klimov <klimov.linux@gmail.com>
To: Ming-Ching Tiew <mctiew@yahoo.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Ming-Ching,

On Mon, Oct 19, 2009 at 10:28 AM, Ming-Ching Tiew <mctiew@yahoo.com> wrote:
>
> Message below :-
>
>> From: Ming-Ching Tiew <mctiew@yahoo.com>
>> Subject: Re: Gadmei 380 on kernel 2.6.28.4
>> To: linux-media@vger.kernel.org
>> Date: Monday, October 12, 2009, 8:31 AM
>> I did a dmesg, include please find
>> the output. If you see
>> carefully, towards the end, there is a USB driver error,
>> and my KINGSTON usb thumb drive get disconnected and
>> reconnected again.

Yes, there is error "usb 1-5: failed to restore interface 0 altsetting
0 (error=-71)"
If i understand things correctly this is "Protocol error".
I have small idea that this can be problem with electrical power
system on usb bus.

>> --- On Mon, 10/12/09, mctiew <mctiew@yahoo.com>
>> wrote:
>>
>> > From: mctiew <mctiew@yahoo.com>
>> > Subject: Gadmei 380 on kernel 2.6.28.4
>> > To: linux-media@vger.kernel.org
>> > Date: Monday, October 12, 2009, 3:32 AM
>> >
>> > I am trying to use the gadmei 380 which I bought
>> > yesterday.
>> >
>> > I am using kernel 2.6.28.4, I downloaded the entire
>> > ~dougsland/em28xx
>> > and did a make and install. Everything went on
>> smoothly.
>> > However,
>> > when I plug in the gadmei 380 usb device, it seems
>> the
>> > driver can
>> > get loaded by the usb pnp, but at the same time, one
>> of my
>> > usb
>> > pendrive will get disconnected. Because that's my
>> boot
>> > drive
>> > ( I boot off from the usb drive ), that will cause
>> problem
>> > with
>> > my system.
>> >
>> > Anyone has experienced this before ?
>> >
>> >
>
> No one is working on this ? Is there a similar device which
> I can use as a reference ? I am thinking maybe I need to
> modify the usb storage driver to ignore this device much
> like this thread ?
>
> http://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg54175.html

Well, if there is no answers on this maillist, it's very good if you
can ask linux usb team. Maillist is linux-usb@vger.kernel.org. Logs of
em28xx driver contains no v4l-dbv or even usb errors. If usb guys say
that there is em28xx driver problem it will makes things more clear.


-- 
Best regards, Klimov Alexey
