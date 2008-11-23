Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dd16712.kasserver.com ([85.13.137.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vdr@helmutauer.de>) id 1L4L4v-0007Hw-Uy
	for linux-dvb@linuxtv.org; Sun, 23 Nov 2008 20:57:10 +0100
Received: from [192.168.178.120] (p50812E1C.dip0.t-ipconnect.de [80.129.46.28])
	by dd16712.kasserver.com (Postfix) with ESMTP id 551BA180FBD9E
	for <linux-dvb@linuxtv.org>; Sun, 23 Nov 2008 20:57:11 +0100 (CET)
Message-ID: <4929B59C.3010604@helmutauer.de>
Date: Sun, 23 Nov 2008 20:57:16 +0100
From: Helmut Auer <vdr@helmutauer.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Some thoughts about v4l-hg repository
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

Hi List,

I am just writing down my definitly subjective opinion aboit the v4-hg 
repository.
I am not a developer of dvb drivers, I have a small gento based 
distribution with vdr as main application.
The troubles which I have with v4l drivers are growing from  release to 
release.
In the moment I have to decide if I take multiproto or s2 as base, and 
there are pro's and con's ...
There are some repositories around which will support different drivers 
( is there a list somewhere ) and I am going to get lost in this "jungle".
In my eyes the v4l has grown into a beast which cannot be handled for a 
distribution.
There are 3 open issues which I've posted to this ML and never have been 
solved and also some others drivers ( cablestar ) are still not working, 
or will break from changeset to changeset.
So in the feature I will make my live much easier and will build the 
distribution just with a handful of drivers.
Supporting more costs much too much time with a ML which cannot (or will 
not) help.

-- 
Helmut Auer, helmut@helmutauer.de 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
