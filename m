Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44247 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752005AbZBQUgk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 15:36:40 -0500
Message-ID: <499B1FD1.9080908@gmx.de>
Date: Tue, 17 Feb 2009 21:36:33 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: DVB v3 API question
References: <200902162350.50319.hverkuil@xs4all.nl> <20090216222339.5ebad80d@pedra.chehab.org>
In-Reply-To: <20090216222339.5ebad80d@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> On Mon, 16 Feb 2009 23:50:50 +0100
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>   
>> Hi all,
>>
>> I've made a v4l-dvb tree containing the old DVB API sources as found here: 
>> http://www.linuxtv.org/cgi-bin/viewcvs.cgi/DVB/doc/dvbapi/.
>>
>> This tree is here: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-api
>>     
>
> It seems that we did suplicate work, except that, on your tree, you just
> dropped all CVS history.
>
> Anyway, the DVB API were just added to the repository with all the CVS history.
>
>   
>> Run 'make spec' to build both the v4l2-spec and the dvb-spec, or 
>> run 'make -C dvb-spec' to build only the latter. You'll need the transfig 
>> package to get the dvb-spec to compile.
>>     
>
> I didn't touch at the Makefiles. Feel free to submit this as a patch for the
> current tip.
>
>   
>> My question is if this is indeed the most recent version that we have? There 
>> is a dvb-api-v4 pdf document, but it is my understanding that v4 was 
>> actually never implemented and never got beyond the proposal stage. Is that 
>> correct? Or are there bits and pieces that were actually used?
>>     
>
>   
>> The original documentation for v4 is here: 
>> http://www.linuxtv.org/cgi-bin/viewcvs.cgi/dvb-kernel-v4/linux/Documentation/dvb/
>>     
>
> V4 is a proposal that were never finished.
>
> We're currently using V3 + S2API. This is named as V5.
>
> We need, of course, to update the docs to rename it to Version 5 and add S2API
> specs there. We should also review if the current DVB core and drivers match
> the V3. I suspect that maybe there are other changes that aren't applied yet at
> the docs.
>
>   

Thanks Mauro and Hans for your fast help, its a good starting point for 
updates.
The compiling requirements are not complete, missing are
- TransFig/fig2dev from xfig homepage
- dvipdf (where to find that btw..?)


The last one, dvipdf can be replaced by "dvipdfm", which is part of 
teTex-3.0 which is anyway needed by only changing one line in Makefile:

dvbapi.pdf: dvbapi.dvi
-    dvipdf  $< $@
+    dvipdfm -o $@ $<

Regards,
Winfried
