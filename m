Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt2.poste.it ([62.241.5.253])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nicola.sabbi@poste.it>) id 1KPjRO-0005Pq-Tm
	for linux-dvb@linuxtv.org; Sun, 03 Aug 2008 21:40:31 +0200
Received: from [192.168.1.116] (79.42.63.17) by relay-pt2.poste.it (7.3.122)
	(authenticated as nicola.sabbi@poste.it)
	id 4894E73E000062AB for linux-dvb@linuxtv.org;
	Sun, 3 Aug 2008 21:40:27 +0200
From: Nico Sabbi <nicola.sabbi@poste.it>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
In-Reply-To: <3C276393607085468A28782D978BA5EE6ED36D11F6@w2k8svr1.glcdomain8.local>
References: <3C276393607085468A28782D978BA5EE6ED36D11F5@w2k8svr1.glcdomain8.local>
	<1217786689.4109.0.camel@suse.site>
	<3C276393607085468A28782D978BA5EE6ED36D11F6@w2k8svr1.glcdomain8.local>
Date: Sun, 03 Aug 2008 21:44:09 +0200
Message-Id: <1217792649.3745.1.camel@suse.site>
Mime-Version: 1.0
Subject: Re: [linux-dvb] dvbstream compile on the  on fedora 2.6.25 x86_64
Reply-To: nicola.sabbi@poste.it
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

Il giorno dom, 03/08/2008 alle 19.51 +0100, Michael J. Curtis ha
scritto:
> Hi Nico
> 
> I seem to remember your name coming up during my searching, am I correct in thinking that you are one of the maintainers?

yes

> 
> Can you please supply a link to the CVS repo?
> 
> Regards
> 
> Mike Curtis
> 

instructions here: 
http://sourceforge.net/cvs/?group_id=50669

in particular 
$ cvs
-d:pserver:anonymous@dvbtools.cvs.sourceforge.net:/cvsroot/dvbtools
login 
 
$ cvs -z3
-d:pserver:anonymous@dvbtools.cvs.sourceforge.net:/cvsroot/dvbtools co
-P modulename


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
