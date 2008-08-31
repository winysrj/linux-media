Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f22.mail.ru ([194.67.57.55])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KZiXi-0008AZ-N3
	for linux-dvb@linuxtv.org; Sun, 31 Aug 2008 10:44:19 +0200
Received: from mail by f22.mail.ru with local id 1KZiXA-00027R-00
	for linux-dvb@linuxtv.org; Sun, 31 Aug 2008 12:43:44 +0400
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0
Date: Sun, 31 Aug 2008 12:43:44 +0400
In-Reply-To: <195222.73778.qm@web46109.mail.sp1.yahoo.com>
References: <195222.73778.qm@web46109.mail.sp1.yahoo.com>
Message-Id: <E1KZiXA-00027R-00.goga777-bk-ru@f22.mail.ru>
Subject: Re: [linux-dvb]
	=?koi8-r?b?Y2F0OiAvZGV2L2R2Yi9hZGFwdGVyMC9kdnIwOiBW?=
	=?koi8-r?b?YWx1ZSB0b28gbGFyZ2UgZm9yIGRlZmluZWQgZGF0YSB0eXBl?=
Reply-To: Goga777 <goga777@bk.ru>
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

> > "cat: /dev/dvb/adapter0/dvr0: Value too large for
> > defined data type"
> > 
> > is it possible to fix it ?
> 
> This is a result of error EOVERFLOW.
> 
> I found mention of this in some very old documentation I have
> but which doesn't appear to be present in the very limited
> searching I've done on the existing source repositories.
> 
> I also can't find a particular pointer I read years back, which
> led me to tweak the value of DVB_BUFFER_SIZE in dvb-core/dmxdev.h
> so solve some problem I can't remember.
> 
> The documentation points to DMX_SET_BUFFER_SIZE.  Programs like
> `szap' seem to set this to 64k.
> 
> Hope that gets you started in the right direction...



so, google has found this link
http://panteltje.com/panteltje/dvd/

======================================================
Attention,
if you do cat /dev/dvb/adapter0/dvr0 > file.ts and get error 'Value too large for defined data type', 
then this indicates a buffer overflow in the DVB driver! 
In this case modify dmxdev.h in the DVB driver so it reads: 
#define DVR_BUFFER_SIZE (100*188*1024) // was 10*188*1024 
You can do this if you have a kernel source >= 2.6 in the driver (check with uname -a): 
/usr/src/linux/drivers/media/dvb/dvb-core/dmxdev.h 
then recompile (make modules?). 
======================================================


I have corrected /usr/src/liplianindvb/linux/drivers/media/dvb/dvb-core/dmxdev.h

#define DVR_BUFFER_SIZE (100*188*1024)

but it didn't help me and after re-compilation I have the same problem

Goga


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
