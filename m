Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226Ab3ETVWU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 May 2013 17:22:20 -0400
Date: Mon, 20 May 2013 18:22:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media" <linux-media@vger.kernel.org>
Subject: Re: Can you take a look at these dvb-apps warnings/errors?
Message-ID: <20130520182215.54e2e3b0@redhat.com>
In-Reply-To: <201305171030.57794.hverkuil@xs4all.nl>
References: <201305171030.57794.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Em Fri, 17 May 2013 10:30:57 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> Can you take a look at these? The daily build is failing because of this.
> 
> Thanks!
> 
> 	Hans
> 
> test_video.c:322:2: warning: format ‘%d’ expects argument of type ‘int’, but argument 2 has type ‘ssize_t’ [-Wformat]
> dvbscan.c:128:6: warning: variable ‘output_type’ set but not used [-Wunused-but-set-variable]
> dvbscan.c:126:6: warning: variable ‘uk_ordering’ set but not used [-Wunused-but-set-variable]
> dvbscan.c:124:32: warning: variable ‘inversion’ set but not used [-Wunused-but-set-variable]
> dvbscan_dvb.c:27:44: warning: unused parameter ‘fe’ [-Wunused-parameter]
> dvbscan_atsc.c:27:45: warning: unused parameter ‘fe’ [-Wunused-parameter]
> util.c:193:7: error: ‘SYS_DVBC_ANNEX_A’ undeclared (first use in this function)
> util.c:194:7: error: ‘SYS_DVBC_ANNEX_C’ undeclared (first use in this function)
> util.c:262:26: error: ‘DTV_ENUM_DELSYS’ undeclared (first use in this function)
> util.c:263:1: warning: control reaches end of non-void function [-Wreturn-type]
> make[2]: *** [util.o] Error 1
> make[1]: *** [all] Error 2
> make: *** [all] Error 2

I'm not touching on dvb-apps for a long time. From my side, all I need in
terms of userspace apps for DVB is there at dvbv5/libdvbv5 on v4l-utils.

That's said, from the above errors, it seems that it got added (partial)
support for DVB v5 but, somehow, it is compiling with an older
dvb/frontend.h header on your build.

Regards,
Mauro
