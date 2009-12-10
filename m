Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.188]:63498 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760980AbZLJQ4X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 11:56:23 -0500
Received: by gv-out-0910.google.com with SMTP id r4so10179gve.37
        for <linux-media@vger.kernel.org>; Thu, 10 Dec 2009 08:56:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1259106230.3069.16.camel@palomino.walls.org>
References: <34373e030911241005r7f499297y1a84a93e0696f550@mail.gmail.com>
	 <1259106230.3069.16.camel@palomino.walls.org>
Date: Thu, 10 Dec 2009 11:56:29 -0500
Message-ID: <34373e030912100856r2ba80741yca8f79c84ee730e3@mail.gmail.com>
Subject: Re: [linux-dvb] Hauppauge PVR-150 Vertical sync issue?
From: Robert Longfield <robert.longfield@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok I've been able to do some troubleshooting with some interesting results.
I removed the one splitter being used, connected to the main cable
coming into the house, isolated the grounds with no change in sync
issues.
I pulled the pvr-150 card out of the linux machine and put it into my
window box, hooked it up to the original setup splitter and no ground
isolation and the video is crystal clear with no sync issues.

I can only come up with a few possible problems, but I am sure there are more.
Could this be a driver issue on my linux box?
Could a bad or failing PCI slot cause this problem? However the sync
problem is not on every channel.

I'm going to try moving the linux box across the house to see if there
is a source of EMI near by, but since the windows box doesn't have
this issue I assume this is a problem with the linux box.

-Rob

On Tue, Nov 24, 2009 at 6:43 PM, Andy Walls <awalls@radix.net> wrote:
> On Tue, 2009-11-24 at 13:05 -0500, Robert Longfield wrote:
>> I have a PVR-150 card running on mythbuntu 9 and it appears that my
>> card is suffering a vertical (and possibly a horizontal) sync issue.
>>
>> The video jumps around, shifts from side to side, up and down and when
>> it shifts the video wraps. I'm including a link to a screen shot
>> showing the vertical sync problem
>>
>> http://imagebin.ca/view/6fS-14Yi.html
>
> It looks like you have strong singal reflections in your cable due to
> impedance mismatches, a bad splitter, a bad cable or connector, etc.
>
> Please read:
>
> http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality
>
> and take steps to ensure you've got a good cabling plant in your home.
>
> Regards,
> Andy
>
>> This is pretty tame to what happens sometimes. I haven't noticed this
>> on all channels as we are mostly using this to record shows for my
>> son.
>>
>> Here is my setup. Pentium 4 2 Ghz with a gig of ram. 40 gig OS drive,
>> 150 gig drive for recording, 250 gig drive for backup and storage, a
>> dvd-burner.
>> The 150 gig drive is on a Promise Ultra133 TX2 card but exhibits no
>> issues on reads or writes.
>> I have cable connected to the internal tuner of my PVR-150 card and
>> S-video from an Nvidia card (running Nvidea drivers) out to the TV.
>>
>> I don't know what else I can provide to help out but let me know and
>> I'll get it.
>>
>> Thanks,
>> -Rob
>> _______________________________________________
>> linux-dvb users mailing list
>> For V4L/DVB development, please use instead linux-media@vger.kernel.org
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
