Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:52938 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbZKGBna (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2009 20:43:30 -0500
Received: by fg-out-1718.google.com with SMTP id d23so36311fga.1
        for <linux-media@vger.kernel.org>; Fri, 06 Nov 2009 17:43:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <702870ef0911061659q208b73c3te7d62f5a220e9499@mail.gmail.com>
References: <20764.64.213.30.2.1257390002.squirrel@webmail.exetel.com.au>
	 <829197380911050602t30bc69d0sd0b269c39bf759e@mail.gmail.com>
	 <702870ef0911051257k52c142e8ne1b32506f1efb45c@mail.gmail.com>
	 <829197380911051304g1544e277s870f869be14e1a18@mail.gmail.com>
	 <25126.64.213.30.2.1257464759.squirrel@webmail.exetel.com.au>
	 <829197380911051551q3b844c5ek490a5eb7c96783e9@mail.gmail.com>
	 <39786.64.213.30.2.1257466403.squirrel@webmail.exetel.com.au>
	 <40380.64.213.30.2.1257474692.squirrel@webmail.exetel.com.au>
	 <829197380911051843r4a55bddcje8c014f5548ca247@mail.gmail.com>
	 <702870ef0911061659q208b73c3te7d62f5a220e9499@mail.gmail.com>
Date: Fri, 6 Nov 2009 20:43:34 -0500
Message-ID: <829197380911061743o64c4661gfdee5c65f680904e@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: Robert Lowery <rglowery@exemail.com.au>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please excuse the top post. This is coming from my phone.

Vincent, please confirm exactly which of your boards is not working.
Roberts patch is not a general fix and only applies to his EXACT
product .

please provide the pci/usb I'd in question.

thanks,

devin

On 11/6/09, Vincent McIntyre <vincent.mcintyre@gmail.com> wrote:
> I tried this patch, on 2.6.24-23-rt and 2.6.31-14-generic
> .
> On the first, it appears to work fine. Thanks again Rob!
>
> On the second, while the kernel seems happy I am unable to get any
> applications to tune the card, when I use the latest v4l tree + Rob's
> patch (40705fec2fb2 tip).
>
>  * dvbscan fails with 'unable to query frontend status'
>
>  * vlc is unable to tune as well
> [0x9c2cf50] dvb access error: DVB-T: setting frontend failed (-1):
> Invalid argument
> [0x9c2cf50] dvb access error: DVB-T: tuning failed
> [0xb7400c18] main input error: open of `dvb://frequency=177500' failed:
> (null)
>
>
>  * w_scan fails a bit more informatively
> w_scan version 20090808 (compiled for DVB API 5.0)
> using settings for AUSTRALIA
> DVB aerial
> DVB-T AU
> frontend_type DVB-T, channellist 3
> output format vdr-1.6
> Info: using DVB adapter auto detection.
>         /dev/dvb/adapter0/frontend0 -> DVB-T "Zarlink ZL10353 DVB-T": good
> :-)
>         /dev/dvb/adapter1/frontend0 -> DVB-T "Zarlink ZL10353 DVB-T": good
> :-)
>         /dev/dvb/adapter2/frontend0 -> DVB-T "Zarlink ZL10353 DVB-T": good
> :-)
>         /dev/dvb/adapter3/frontend0 -> DVB-T "Zarlink ZL10353 DVB-T": good
> :-)
> Using DVB-T frontend (adapter /dev/dvb/adapter0/frontend0)
> -_-_-_-_ Getting frontend capabilities-_-_-_-_
> Using DVB API 5.1
> frontend Zarlink ZL10353 DVB-T supports
> INVERSION_AUTO
> QAM_AUTO
> TRANSMISSION_MODE_AUTO
> GUARD_INTERVAL_AUTO
> HIERARCHY_AUTO
> FEC_AUTO
> -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
> Scanning 7MHz frequencies...
> 177500: (time: 00:00) set_frontend:1690: FATAL: unsupported DVB API Version
> 5.1
>
> Presumably this is all understood and expected (i.e. application
> authors are updating their code?)
>
> Is there a way to build with the API set to version 5.0?
>
> I was able to use vlc and w_scan ok with Rob's module option
> workaround and the stock modules from ubuntu. I will have a go at
> building their source + Rob's patch.
>
>
> On 11/6/09, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
>> On Thu, Nov 5, 2009 at 9:31 PM, Robert Lowery <rglowery@exemail.com.au>
>> wrote:
>>> Devin,
>>>
>>> I have confirmed the patch below fixes my issue.  Could you please merge
>>> it for me?
>>>
>>> Thanks
>>>
>>> -Rob
>>
>> Sure.  I'm putting together a patch series for this weekend with a few
>> different misc fixes.
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller - Kernel Labs
>> http://www.kernellabs.com
>>
>


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
