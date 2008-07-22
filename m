Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway14.websitewelcome.com ([69.93.179.25])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1KLHsh-00078z-K8
	for linux-dvb@linuxtv.org; Tue, 22 Jul 2008 15:26:20 +0200
Message-ID: <4885DFF3.7030903@kipdola.com>
Date: Tue, 22 Jul 2008 15:26:11 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Daniel_Hellstr=F6m?= <dvenion@hotmail.com>,
	LinuxTV DVB Mailing <linux-dvb@linuxtv.org>
References: <200807170023.57637.ajurik@quick.cz>	<3efb10970807170320w39377ae9p9db0081dda9c3f5f@mail.gmail.com>	<1216295683l.6831l.1l@manu-laptop>
	<loom.20080717T154146-799@post.gmane.org>
In-Reply-To: <loom.20080717T154146-799@post.gmane.org>
Subject: Re: [linux-dvb] Re :  TT S2-3200 driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Daniel Hellstr=F6m schreef:
> manu <eallaud <at> yahoo.fr> writes:
>   =

>> If you want to use myth you can try the attached patch (against trunk).
>> Make sure that the includes in /usr/include/linux/dvb/ are the one from =

>> your multiproto tree (check for a DVBFE_SET_DELSYS define in the =

>> frontend.h source).
>> Bye
>> Manu
>>     =

> I use the patch on this site to add multiprotosupport to MythTV
>
> http://svn.mythtv.org/trac/ticket/5403
>
> It also modifies the channelscanning section in mythtv-setup so you can s=
et the
> modulationtype for the transpor
Slightly off-topic, I know (It's the linux-dvb mailing list, and not the =

mythtv one) but could you tell me what revision you where using?

This patch (version 5) keeps failing on me, things seem to have changed =

too much in a few days. Not even manu's patch works.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
