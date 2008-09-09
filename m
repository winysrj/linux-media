Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KcyUI-0007qz-Vi
	for linux-dvb@linuxtv.org; Tue, 09 Sep 2008 10:22:16 +0200
Message-ID: <48C6322D.7030501@gmail.com>
Date: Tue, 09 Sep 2008 12:22:05 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: urishk@yahoo.com
References: <179729.56472.qm@web38808.mail.mud.yahoo.com>
In-Reply-To: <179729.56472.qm@web38808.mail.mud.yahoo.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Uri Shkolnik wrote:
> Manu and all,
> 
> 
> First I would like to present myself (I'm new to this forum)
> My name is Uri Shkolnik, and I work as Software Architecture at Siano Mobile Silicon (www.siano-ms.com).
> 
> As some people reading this mailing list know, but some don't.... Siano manufactures chipsets that support various of MDTV standards (DVB-H, DVB-T, ISDB-T, CMMB, T-DMB, DAB-IP,... and many more). Many products you see actually uses Siano's chipsets.
> 
> As far as I understand from this thread, and from other threads, the LinuxTV/DVB sub-system will not support non-DVB standards in the near future.
> 

Well, this is not true. What the idea we put forward was thus:

* have an API that is capable of supporting things which are needed in
the future as well, not just for now.

* At the point of working on the same, we mostly worked on DSS, DVB-S2,
DVB-H, also for some DOCSIS cable modems. Since these were somewhat
suppoted on many hardware we had.

* The Linux DVB V4 API supports ISDB-T and is running on some STB's
http://linuxtv.org/cgi-bin/viewcvs.cgi/dvb-kernel-v4/

This is something which has been proven with regards to the ARIB
extensions as well, so we can use the interface of the delivery system
in the new API. But having no open drivers which were really supported,
really was a let down and the scrambling being employed -- was not
something that was open, slowed down things quite a lot, as it was yet
to be seen whether such supported hardware drivers would really exist
under Linux.

* With regards to DMB-T/H or the Chinese T-DMB, there is quite some
people interested on the same, This can be added in to the API at any
point of time, without sacrificing backward binary compatibility.

* There was even DVB-T2 in the works at that time, but it was argued and
proven right that we shouldn't just blindly keep adding things till we
really have support on the same.

You can see my post over here:
http://thread.gmane.org/gmane.linux.kernel/729969

> This is quite understandable since those standards are quite complicate, and the newer are even more complicated than DVB-C/S/T. It took about 5 years for the DVB sub-system to become mature, so, trying to add all of those standards at once will lead to nowhere good.
> 

True, one must look first what hardware will the general home user would
like to get going under Linux. There are some features professional
users also would like to get going.

But adding all the definitions into an API will be just a mess:
for example ATSC over satellite was a standard that was put forward at
some point of time and later on the whole standard itself was scrapped
in favour of DVB over satellite.

> I don't know what should be done next, which API (and sub-system) should be added first, second, ... (or not at all?). I have my own views (CMMB getting much more audience than DVB-H and ISDB-T more than the DAB family). 
> 
> But, I can offer technical assistant. Siano is senior member at most of the MDTV consortiumes (CMMB, DVB and more) and I have access to lot of technical documentation (specifications, guildlines, etc.) which are otherwise quite hard (if not impossible) to be obtained.
> True that some (not all) of those papers are under classification that does not permit me to share them directly, but always a specific question can be answered.

That would be nice. Well, there are quite some vendors who are willing
to help as well. Some of us have access to some of the consortiums,
AFAICS. If there's supported hardware out there, we can add in support
in the API too, for the relevant delivery systems.

The easiest way to do so, will be to start a discussion, on a newer
thread as to what you will need in terms of API support in a newer
delivery system.

> One point regarding Siano non-DVB offering - With Michael Krufky's help, I'm trying to find a way to add Siano's non-DVB(-T) offering into the kernel's code base (till now we supply a proprietary sources directly to our customers). Of course it will be somewhat specific code by the fact that it'll match Siano's chipset instead of be more generic.
> 


Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
