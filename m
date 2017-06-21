Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53116
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751434AbdFUJvn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 05:51:43 -0400
Date: Wed, 21 Jun 2017 06:51:35 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Thierry Lelegard <thierry.lelegard@free.fr>
Cc: thierry@lelegard.fr, linux-media@vger.kernel.org
Subject: Re: LinuxTV V3 vs. V4 API doc inconsistency, V4 probably wrong
Message-ID: <20170621065135.319ca04e@vento.lan>
In-Reply-To: <ce5e9d6a3b4aafdcec9ee672a6d15322@free.fr>
References: <3188f2a2bcba758dccaaa8cdbbd694fb@free.fr>
        <20170619140806.7e92ae66@vento.lan>
        <ce5e9d6a3b4aafdcec9ee672a6d15322@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 21 Jun 2017 09:34:01 +0200
Thierry Lelegard <thierry.lelegard@free.fr> escreveu:

> Hi Mauro,
> 
> > First of all, there's no Linux DVB API v4. It was skipped, because 
> > there
> > was a proposal for a v4, with was never adopted.  
> 
> Alright, whatever, you have understood it was the post-V3 API, S2API, 
> you name it.
> You should assign it a version number by the way.

S2API was merged as DVBv5. The current version is 5.10, as documented
at:
	https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/dvb/dvbapi.html

(The minor review tracks other features added after DVB-S2 support,
like DVBv5 stats)

> > Thanks for reviewing it! Yeah, the asterisks there are wrong.
> > The definitions should be, instead:
> > 
> > int ioctl(int fd, FE_SET_TONE, enum fe_sec_tone_mode tone)
> > int ioctl(int fd, FE_SET_VOLTAGE, enum fe_sec_voltage voltage)
> > int ioctl(int fd, FE_DISEQC_SEND_BURST, enum fe_sec_mini_cmd tone)
> > 
> > As they're passing by value, not by reference[1].  
> 
> Thanks for the clarification.
> 
> > Feel free to send us fix patches.  
> 
> Do you suggest I should locate the repository, clone it, understand the 
> structure,
> locate the documentation files, etc? That would take 20 times the time 
> it takes to
> remove the 3 asterisk characters when you already master the source code 
> as you
> probably do.

It is not hard to find it. All documentation is under Documentation/. A simple
git grep at the git tree would tell you exactly where:

$ git grep FE_SET_TONE Documentation/
Documentation/media/uapi/dvb/fe-set-tone.rst:.. _FE_SET_TONE:
Documentation/media/uapi/dvb/fe-set-tone.rst:ioctl FE_SET_TONE
Documentation/media/uapi/dvb/fe-set-tone.rst:FE_SET_TONE - Sets/resets the generation of the continuous 22kHz tone.
Documentation/media/uapi/dvb/fe-set-tone.rst:.. c:function:: int ioctl( int fd, FE_SET_TONE, enum fe_sec_tone_mode *tone )
Documentation/media/uapi/dvb/fe-set-tone.rst:    :name: FE_SET_TONE

or, even better:

$ git grep 'int.*ioctl.*enum' Documentation/media/uapi/dvb/
Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst:.. c:function:: int ioctl( int fd, FE_DISEQC_SEND_BURST, enum fe_sec_mini_cmd *tone )
Documentation/media/uapi/dvb/fe-set-tone.rst:.. c:function:: int ioctl( int fd, FE_SET_TONE, enum fe_sec_tone_mode *tone )
Documentation/media/uapi/dvb/fe-set-voltage.rst:.. c:function:: int ioctl( int fd, FE_SET_VOLTAGE, enum fe_sec_voltage *voltage )

	
> 
> I own a few opensource projects on sourceforge and github. When a user 
> reports
> a problem, whether it is a functional one or a documentation typo, I fix 
> it myself.
> I do not expect users to do it for me. For those projects, I am the 
> developer and
> they are the users. I welcome contributions, but I do not demand or even 
> expect them.

In a project of the size of the Kernel, that typically has 10K+ changes
per kernel version, released on every 2 months, it works a way better
if people can send us patches, as we're usually too crowd of work. So,
we usually help people to do the changes themselves and submit, as,
in long term, this usually works best for everybody.

In this specific case, I'll do the patch.

Thanks for reporting the issue.

Regards,
Mauro
