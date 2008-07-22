Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway08.websitewelcome.com ([67.18.66.17])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1KLQ0N-0007sL-HK
	for linux-dvb@linuxtv.org; Wed, 23 Jul 2008 00:06:50 +0200
Received: from [77.109.104.69] (port=58388 helo=[192.168.1.13])
	by gator143.hostgator.com with esmtpa (Exim 4.68)
	(envelope-from <skerit@kipdola.com>) id 1KLQ0E-0008Oz-Uk
	for linux-dvb@linuxtv.org; Tue, 22 Jul 2008 17:06:39 -0500
Message-ID: <488659EC.3080208@kipdola.com>
Date: Wed, 23 Jul 2008 00:06:36 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] More multiproto & mythtv errors
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1342781467=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1342781467==
Content-Type: multipart/alternative;
 boundary="------------010409070205050209080307"

This is a multi-part message in MIME format.
--------------010409070205050209080307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Hi everyone,

I don't know how, I don't know why, but the multiproto drivers are 
acting up AGAIN.

I performed all these steps earlier today on a machine that was running 
VDR for months without a problem.
I thought I had purged all of my earlier compiles of multiproto and 
mythtv, but somehow it worked on the "dirty" machine and on my new, 
completely clean, reinstalled machine it's not working anymore.

I installed the drivers with these instructions:

    mkdir -p /opt/dvb
    cd /opt/dvb
    hg clone -r 7218 http://jusst.de/hg/multiproto
    cd /opt/dvb/multiproto/v4l
    mv compat.h compat.h.untouched
    wget http://skerit.kipdola.com/wp-content/uploads/multiproto/compat.h
    cd ..
    cd /opt/dvb/multiproto/linux/drivers/media/dvb/frontends
    wget
    http://skerit.kipdola.com/wp-content/uploads/multiproto/stb6100.c.diff
    patch -p0 < stb6100.c.diff
    cd /opt/dvb/multiproto/linux/drivers/media/common
    wget
    http://skerit.kipdola.com/wp-content/uploads/multiproto/TT-3200-remote.patch
    patch < TT-3200-remote.patch
    cd /opt/dvb/multiproto
    make
    make install


And I installed mythtv with these:

    cd /opt
    svn co http://svn.mythtv.org/svn/branches/release-0-21-fixes/

    cd /opt/release-0-21-fixes/mythtv/libs/libmythtv
    wget
    http://svn.mythtv.org/trac/raw-attachment/ticket/5403/mythtv_multiproto.5.patch
    patch < mythtv_multiproto.5.patch
    cp /opt/dvb/multiproto/linux/include/linux/dvb/* /usr/include/linux/dvb/
    cd /opt/release-0-21-fixes/mythtv
    ./configure --enable-dvb --dvb-path=/opt/dvb/multiproto/linux/include/
    make
    make install
    cd /opt/release-0-21-fixes/mythtv/database
    /mysql/ //< /mc.sql/ -p

Now, I'm getting this error message in mythtv:

    2008-07-23 00:05:05.885 DVBSM(0), Error: Can not read DVB status
                eno: Ongeldig argument (22)
    2008-07-23 00:05:05.885 DVBSM(0), Warning: Can not measure Signal
    Strength
                eno: Ongeldig argument (22)
    2008-07-23 00:05:05.885 DVBSM(0), Warning: Can not measure S/N
                eno: Ongeldig argument (22)
    2008-07-23 00:05:05.885 DVBSM(0), Warning: Can not measure Bit Error
    Rate
                eno: Ongeldig argument (22)
    2008-07-23 00:05:05.886 DVBSM(0), Warning: Can not count Uncorrected
    Blocks
                eno: Bewerking wordt niet ondersteund (95)
    mythtv-setup: ../../src/xcb_lock.c:77: _XGetXCBBuffer: Controletest
    '((int) ((xcb_req) - (dpy->request)) >= 0)' faalt.
    Afgebroken


-- 

/Met vriendelijke groeten,/

*Jelle De Loecker*
Kipdola Studios - Tomberg


--------------010409070205050209080307
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
</head>
<body bgcolor="#ffffff" text="#000000">
<br>
Hi everyone,<br>
<br>
I don't know how, I don't know why, but the multiproto drivers are
acting up AGAIN.<br>
<br>
I performed all these steps earlier today on a machine that was running
VDR for months without a problem.<br>
I thought I had purged all of my earlier compiles of multiproto and
mythtv, but somehow it worked on the "dirty" machine and on my new,
completely clean, reinstalled machine it's not working anymore.<br>
<br>
I installed the drivers with these instructions:<br>
<br>
<blockquote>mkdir -p /opt/dvb<br>
cd /opt/dvb<br>
hg clone -r 7218 <a class="moz-txt-link-freetext" href="http://jusst.de/hg/multiproto">http://jusst.de/hg/multiproto</a><br>
cd /opt/dvb/multiproto/v4l<br>
mv compat.h compat.h.untouched<br>
wget <a class="moz-txt-link-freetext" href="http://skerit.kipdola.com/wp-content/uploads/multiproto/compat.h">http://skerit.kipdola.com/wp-content/uploads/multiproto/compat.h</a><br>
cd ..<br>
cd /opt/dvb/multiproto/linux/drivers/media/dvb/frontends<br>
wget
<a class="moz-txt-link-freetext" href="http://skerit.kipdola.com/wp-content/uploads/multiproto/stb6100.c.diff">http://skerit.kipdola.com/wp-content/uploads/multiproto/stb6100.c.diff</a><br>
patch -p0 &lt; stb6100.c.diff<br>
cd /opt/dvb/multiproto/linux/drivers/media/common<br>
wget
<a class="moz-txt-link-freetext" href="http://skerit.kipdola.com/wp-content/uploads/multiproto/TT-3200-remote.patch">http://skerit.kipdola.com/wp-content/uploads/multiproto/TT-3200-remote.patch</a><br>
patch &lt; TT-3200-remote.patch<br>
cd /opt/dvb/multiproto<br>
make<br>
make install<br>
</blockquote>
<br>
And I installed mythtv with these:<br>
<br>
<blockquote>
  <p>cd /opt<br>
svn co <a class="moz-txt-link-freetext" href="http://svn.mythtv.org/svn/branches/release-0-21-fixes/">http://svn.mythtv.org/svn/branches/release-0-21-fixes/</a></p>
  <p>cd /opt/release-0-21-fixes/mythtv/libs/libmythtv<br>
wget
<a class="moz-txt-link-freetext" href="http://svn.mythtv.org/trac/raw-attachment/ticket/5403/mythtv_multiproto.5.patch">http://svn.mythtv.org/trac/raw-attachment/ticket/5403/mythtv_multiproto.5.patch</a><br>
patch &lt; mythtv_multiproto.5.patch<br>
cp /opt/dvb/multiproto/linux/include/linux/dvb/* /usr/include/linux/dvb/<br>
cd /opt/release-0-21-fixes/mythtv<br>
./configure --enable-dvb --dvb-path=/opt/dvb/multiproto/linux/include/<br>
make<br>
make install<br>
cd /opt/release-0-21-fixes/mythtv/database<br>
  <em>mysql</em> <em></em>&lt; <em>mc.sql</em> -p<br>
  </p>
</blockquote>
<p>Now, I'm getting this error message in mythtv:<br>
</p>
<blockquote>2008-07-23 00:05:05.885 DVBSM(0), Error: Can not read DVB
status<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; eno: Ongeldig argument (22)<br>
2008-07-23 00:05:05.885 DVBSM(0), Warning: Can not measure Signal
Strength<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; eno: Ongeldig argument (22)<br>
2008-07-23 00:05:05.885 DVBSM(0), Warning: Can not measure S/N<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; eno: Ongeldig argument (22)<br>
2008-07-23 00:05:05.885 DVBSM(0), Warning: Can not measure Bit Error
Rate<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; eno: Ongeldig argument (22)<br>
2008-07-23 00:05:05.886 DVBSM(0), Warning: Can not count Uncorrected
Blocks<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; eno: Bewerking wordt niet ondersteund (95)<br>
mythtv-setup: ../../src/xcb_lock.c:77: _XGetXCBBuffer: Controletest
'((int) ((xcb_req) - (dpy-&gt;request)) &gt;= 0)' faalt.<br>
Afgebroken<br>
</blockquote>
<br>
<div class="moz-signature">-- <br>
<br>
<em>Met vriendelijke groeten,</em>
<br>
<br>
<strong>Jelle De Loecker</strong>
<br>
Kipdola Studios - Tomberg <br>
<br>
</div>
</body>
</html>

--------------010409070205050209080307--


--===============1342781467==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1342781467==--
