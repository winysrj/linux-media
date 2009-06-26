Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f191.google.com ([209.85.210.191]:46399 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZFZRnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 13:43:00 -0400
Received: by yxe29 with SMTP id 29so444929yxe.33
        for <linux-media@vger.kernel.org>; Fri, 26 Jun 2009 10:43:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197380906260642m2cd87ae5qd6487dc5eae91e51@mail.gmail.com>
References: <COL103-W53A73F78F552D9FD9BAA2A88350@phx.gbl>
	 <1246017001.4755.4.camel@palomino.walls.org>
	 <829197380906260642m2cd87ae5qd6487dc5eae91e51@mail.gmail.com>
Date: Fri, 26 Jun 2009 13:19:23 -0400
Message-ID: <b24e53350906261019u45bba60erc7ee41222896388b@mail.gmail.com>
Subject: Re: Bah! How do I change channels?
From: Robert Krakora <rob.krakora@messagenetsystems.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Andy Walls <awalls@radix.net>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 26, 2009 at 9:42 AM, Devin
Heitmueller<dheitmueller@kernellabs.com> wrote:
> On Fri, Jun 26, 2009 at 7:50 AM, Andy Walls<awalls@radix.net> wrote:
>> I use either v4l2-ctl or ivtv-tune
>>
>> $ ivtv-tune -d /dev/video0 -t us-bcast -c 3
>> /dev/video0: 61.250 MHz
>>
>> $ v4l2-ctl -d /dev/video0 -f 61.250
>> Frequency set to 980 (61.250000 MHz)
>>
>>
>> Regards,
>> Andy
>
> Hello Andy,
>
> I had sent George some email off-list with basically the same
> commands.  I think what might be happening here is the tuner gets
> powered down when not in use, so I think it might be powered down
> between the v4l-ctl command and the running of the other application.
>
> I have sent him a series of commands to try where he modprobes the
> xc3028 driver with "no_poweroff=1", and we will see if that starts
> working.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
>

I had ran into this before with the KWorld a few months back.
However, whatever problem existed that forced me to add
"no_poweroff=1" to modprobe.conf for the em28xx module has went away.
I have been able to use v4l-ctl or ivtv-tune without any problems to
tune analog channels over cable.

-- 
Rob Krakora
Senior Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax
