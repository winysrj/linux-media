Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from web57809.mail.re3.yahoo.com ([68.142.236.87])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <ar.saikia@yahoo.com>) id 1JNRyN-00026c-Fs
	for linux-dvb@linuxtv.org; Fri, 08 Feb 2008 13:04:51 +0100
Date: Fri, 8 Feb 2008 03:15:41 -0800 (PST)
From: ashim saikia <ar.saikia@yahoo.com>
To: Linux_Greg4LinuxDriverHelp <greg@kroah.com>,
	Linux Forum 4 Dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Message-ID: <27494.38829.qm@web57809.mail.re3.yahoo.com>
Subject: [linux-dvb] QUERY REGARDING Rules.make file
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0580026695=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0580026695==
Content-Type: multipart/alternative; boundary="0-1125886943-1202469341=:38829"

--0-1125886943-1202469341=:38829
Content-Type: text/plain; charset=us-ascii

Hi,
I'm trying to compile a driver module for some 2.6.20.15 kernel sources:


The compile of this module always quickly stops. As it seems because

of a missing Rules.make file in the top level kernel source directory,or because if a missing rule to build Rules.make:


So when building the kernel/Debian kernel-package: Is there a special flag for either make or make-kpkg that also creates this, as it seems from above, missing Rules.make


  
Or - alternatively - does the driver source expect to find some rule


somewhere to build this Rules.make file; a rule that in this case it


does not see .. ?

Or- There is no use of Rules.make file in kernel 2.6.x.x and higher. How can I overcome this problem

Can anybody help me out.

Regards




      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs
--0-1125886943-1202469341=:38829
Content-Type: text/html; charset=us-ascii

<html><head><style type="text/css"><!-- DIV {margin:0px;} --></style></head><body><div style="font-family:times new roman, new york, times, serif;font-size:14pt"><span id="purple">Hi,<br>I'm trying to compile a driver module for some 2.6.20.15 kernel sources:
<br><br></span><span id="purple">The compile of this module always quickly stops. As it seems because
</span>
<span id="purple">of a missing Rules.make file in the top level kernel source directory,</span><span id="purple">or because if a missing rule to build Rules.make:
</span>
<br><span id="purple"></span><span id="purple"></span><span id="purple">So when building the kernel/Debian kernel-package: Is there a special</span><span id="purple"> flag for either make or make-kpkg that also creates this, as it seems</span><span id="purple"> from above, missing Rules.make
</span>
<br>&nbsp;&nbsp;<span id="purple"></span><span id="purple"><br>Or - alternatively - does the driver source expect to find some rule
</span>
<br><span id="purple">somewhere to build this Rules.make file; a rule that in this case it
</span>
<br><span id="purple">does not see .. ?<br><br>Or- There is no use of Rules.make file in kernel 2.6.x.x and higher. How can I overcome this problem<br><br>Can anybody help me out.<br><br>Regards<br><br></span></div><br>

      <hr size=1>Never miss a thing.  <a href="http://us.rd.yahoo.com/evt=51438/*http://www.yahoo.com/r/hs"> Make Yahoo your homepage.</a>

</body></html>
--0-1125886943-1202469341=:38829--


--===============0580026695==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0580026695==--
