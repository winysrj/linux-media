Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zeph7r@gmail.com>) id 1KSZg5-0005N8-A5
	for linux-dvb@linuxtv.org; Mon, 11 Aug 2008 17:51:25 +0200
Received: by mu-out-0910.google.com with SMTP id w8so3827425mue.1
	for <linux-dvb@linuxtv.org>; Mon, 11 Aug 2008 08:51:21 -0700 (PDT)
Message-ID: <48A05FF6.7060803@gmail.com>
Date: Mon, 11 Aug 2008 16:51:18 +0100
From: zePh7r <zeph7r@gmail.com>
MIME-Version: 1.0
To: Albert Comerma <albert.comerma@gmail.com>
References: <ea4209750808080532h950d84fud047c135551e1ff1@mail.gmail.com>	
	<489CCD82.5030406@gmail.com>	
	<ea4209750808100251j3d027cable1e5cd81ceb4995@mail.gmail.com>	
	<48A032F4.6000602@gmail.com>	
	<ea4209750808110629oa80b224if6e070be61156109@mail.gmail.com>	
	<48A05AB4.6050602@gmail.com>
	<ea4209750808110840t2da36229ob5a59ed7e0cc4059@mail.gmail.com>
In-Reply-To: <ea4209750808110840t2da36229ob5a59ed7e0cc4059@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Support for Asus My-Cinema U3000Hybrid?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1460171643=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1460171643==
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
Albert Comerma escreveu:
<blockquote
 cite="mid:ea4209750808110840t2da36229ob5a59ed7e0cc4059@mail.gmail.com"
 type="cite">
  <div dir="ltr">That's something related to your distribution, so I
can't help much. Just verify you have gcc and linux-headers and all the
stuff needed installed.<br>
  <br>
Albert<br>
  <br>
  <div class="gmail_quote">2008/8/11 zePh7r <span dir="ltr">&lt;<a
 moz-do-not-send="true" href="mailto:zeph7r@gmail.com">zeph7r@gmail.com</a>&gt;</span><br>
  <blockquote class="gmail_quote"
 style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
    <div bgcolor="#ffffff" text="#000000">
Albert Comerma escreveu:
    <div>
    <div class="Wj3C7c">
    <blockquote type="cite">
      <div dir="ltr">If you look around line 1082 of dib0700_devices.c
you
will find the table of the cards, which refers to the id's you added on
dvb-usb-ids.h. So you must add an entry to that table. I send you the
modified files, so you can see. I also send you a .config file you must
copy on v4l-dvb/v4l/ folder. Then go into v4l-dvb and just type make,
and then as root make install. That should work without problems. To
try all of this you need the dibcom and xceive firmware at /lib/firmware<br>
      <br>
Albert<br>
      <br>
      <div class="gmail_quote">2008/8/11 zePh7r <span dir="ltr">&lt;<a
 moz-do-not-send="true" href="mailto:zeph7r@gmail.com" target="_blank">zeph7r@gmail.com</a>&gt;</span><br>
      <blockquote class="gmail_quote"
 style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Albert
Comerma escreveu:<br>
        <blockquote class="gmail_quote"
 style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
          <div>Sorry, I didn't explained much... it also
took some time to me to understand how it's working... Since xc2028 is
the tunner it has no Id information on the code. The id's are on the
usb bridge code. You should add your deviece id's at;<br>
/v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h and then insert
your device at<br>
/v4l-dvb/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c &nbsp; &nbsp;first the
device descriptors (at arround line 1120) and then the device itself, I
would try it around line 1418. This last file, has already the include
to the xc2028 code and calls the tunner funcions. Looking the code
around this lines I guess you will understand how it works.<br>
          <br>
Albert<br>
          <br>
          </div>
2008/8/9 zePh7r &lt;<a moz-do-not-send="true"
 href="mailto:zeph7r@gmail.com" target="_blank">zeph7r@gmail.com</a>
&lt;mailto:<a moz-do-not-send="true" href="mailto:zeph7r@gmail.com"
 target="_blank">zeph7r@gmail.com</a>&gt;&gt;
          <div><br>
          <br>
&nbsp; &nbsp;Albert Comerma escreveu:<br>
          <br>
&nbsp; &nbsp; &nbsp; &nbsp;Just to clarify things...<br>
          <br>
&nbsp; &nbsp; &nbsp; &nbsp;Xceive chips are just tunners, RF chips, mostly analogue with<br>
&nbsp; &nbsp; &nbsp; &nbsp;some digital interface, they don't do anything with usb or<br>
&nbsp; &nbsp; &nbsp; &nbsp;comunication with the computer, for this reason you need the<br>
&nbsp; &nbsp; &nbsp; &nbsp;dibcom chip, it's a usb bridge + decoder + something else...<br>
&nbsp; &nbsp; &nbsp; &nbsp;To start to develop something you must first be sure of what<br>
&nbsp; &nbsp; &nbsp; &nbsp;chips it's using.<br>
&nbsp; &nbsp; &nbsp; &nbsp;If not you can try blindly if modifying the code for the<br>
&nbsp; &nbsp; &nbsp; &nbsp;U3000-Mini works or Pinnacle 320cx (dibcom 7700 + xceive2028)<br>
&nbsp; &nbsp; &nbsp; &nbsp;work (you just need to add your device usb id's).<br>
          <br>
&nbsp; &nbsp; &nbsp; &nbsp;Albert<br>
          <br>
&nbsp; &nbsp;Thank you for replying Albert.<br>
&nbsp; &nbsp;I've been exploring the files downloaded through the mercurial<br>
&nbsp; &nbsp;repository and though I have found files which seem like they<br>
&nbsp; &nbsp;relate to that purpose in<br>
&nbsp; &nbsp;/v4l-dvb/linux/drivers/media/common/tuners (which are<br>
&nbsp; &nbsp;tuner-xc2028.c , tuner-xc2028.h and tuner-xc2028-types.h) I can't<br>
&nbsp; &nbsp;find any section in the above files with some sort of list of<br>
&nbsp; &nbsp;device ID's so as to resemble them. There should be something like<br>
&nbsp; &nbsp;an xc2028-cards.c right?<br>
&nbsp; &nbsp;This must seem a noob question but this whole process looks like<br>
&nbsp; &nbsp;something someone who's not deeply into this project couldn't do<br>
&nbsp; &nbsp;easily..<br>
          <br>
          <br>
          </div>
        </blockquote>
When I try to compile the drivers I get this:<br>
        <br>
zeph7r@zeph7r-laptop:~/v4l/v4l-dvb&gt; make all<br>
make -C /home/zeph7r/v4l/v4l-dvb/v4l all<br>
make[1]: Entering directory `/home/zeph7r/v4l/v4l-dvb/v4l'<br>
Updating/Creating .config<br>
Preparing to compile for kernel version 2.6.25<br>
File not found: /lib/modules/2.6.25.11-0.1-default/build/.config at
./scripts/make_kconfig.pl line 32, &lt;IN&gt; line 4.<br>
make[1]: *** No rule to make target `.myconfig', needed by
`config-compat.h'. &nbsp;Stop.<br>
make[1]: Leaving directory `/home/zeph7r/v4l/v4l-dvb/v4l'<br>
make: *** [all] Error 2<br>
        <br>
any hints on what might be causing this? I went look at that dir and
found a makedumpfile.config , perhaps I should edit config-compat.h and
set it to go look for that file instead..<br>
      </blockquote>
      </div>
      <br>
      </div>
    </blockquote>
    <br>
    <br>
    </div>
    </div>
Even after I putted .config in v4l-dvb/v4l it is still not compiling:
    <div class="Ih2E3d"><br>
    <br>
zeph7r@zeph7r-laptop:~/v4l/v4l-dvb&gt; make<br>
    </div>
    <div class="Ih2E3d">make -C /home/zeph7r/v4l/v4l-dvb/v4l<br>
    </div>
    <div class="Ih2E3d">make[1]: Entering directory
`/home/zeph7r/v4l/v4l-dvb/v4l'<br>
    </div>
No version yet, using 2.6.25.11-0.1-default
    <div class="Ih2E3d"><br>
make[1]: Leaving directory `/home/zeph7r/v4l/v4l-dvb/v4l'<br>
    </div>
    <div class="Ih2E3d">make[1]: Entering directory
`/home/zeph7r/v4l/v4l-dvb/v4l'<br>
    </div>
scripts/make_makefile.pl<br>
Updating/Creating .config<br>
./scripts/make_kconfig.pl /lib/modules/2.6.25.11-0.1-default/build
/lib/modules/2.6.25.11-0.1-default/build
    <div class="Ih2E3d"><br>
Preparing to compile for kernel version 2.6.25<br>
File not found: /lib/modules/2.6.25.11-0.1-default/build/.config at
./scripts/make_kconfig.pl line 32, &lt;IN&gt; line 4.<br>
    </div>
    <div class="Ih2E3d">make[1]: Leaving directory
`/home/zeph7r/v4l/v4l-dvb/v4l'<br>
    </div>
    <div class="Ih2E3d">make[1]: Entering directory
`/home/zeph7r/v4l/v4l-dvb/v4l'<br>
    </div>
./scripts/make_kconfig.pl /lib/modules/2.6.25.11-0.1-default/build
/lib/modules/2.6.25.11-0.1-default/build
    <div class="Ih2E3d"><br>
Preparing to compile for kernel version 2.6.25<br>
File not found: /lib/modules/2.6.25.11-0.1-default/build/.config at
./scripts/make_kconfig.pl line 32, &lt;IN&gt; line 4.<br>
make[1]: *** No rule to make target `.myconfig', needed by
`config-compat.h'.&nbsp; Stop.<br>
make[1]: Leaving directory `/home/zeph7r/v4l/v4l-dvb/v4l'<br>
make: *** [all] Error 2<br>
    </div>
    <div class="Ih2E3d">zeph7r@zeph7r-laptop:~/v4l/v4l-dvb&gt;<br>
    <br>
    </div>
I even tried copying .config to
/lib/modules/2.6.25.11-0.1-default/build
/lib/modules/2.6.25.11-0.1-default/build but some other error came up
as well<br>
    </div>
  </blockquote>
  </div>
  <br>
  </div>
</blockquote>
<br>
Make, gcc, kernel headers and debug, all of that is installed... can't
I just add these device Id's to already-compiled files in my kernel
tree instead of having to compile it from source?<br>
</body>
</html>


--===============1460171643==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1460171643==--
