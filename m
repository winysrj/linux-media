Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from el-out-1112.google.com ([209.85.162.176])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarrillero@gmail.com>) id 1JpOQz-000870-ET
	for linux-dvb@linuxtv.org; Fri, 25 Apr 2008 15:57:54 +0200
Received: by el-out-1112.google.com with SMTP id y26so1484094ele.11
	for <linux-dvb@linuxtv.org>; Fri, 25 Apr 2008 06:57:48 -0700 (PDT)
Message-ID: <d150a3810804250657s1ff735a6vbd2dfbc8abda29bd@mail.gmail.com>
Date: Fri, 25 Apr 2008 15:57:47 +0200
From: "=?ISO-8859-1?Q?David_D=EDaz_G=F3mez?=" <jarrillero@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Compilation problem with Ubuntu 8.04
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0715269809=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0715269809==
Content-Type: multipart/alternative;
	boundary="----=_Part_3974_27729160.1209131867727"

------=_Part_3974_27729160.1209131867727
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I'm a newbie in linux, recently i have updated to Ubuntu 8.04 and when i try
to install v4l-dvb the script send me an error.

/home/david/Escritorio/v4l-dvb/v4l/videocodec.c: In function
'videocodec_init':
/home/david/Escritorio/v4l-dvb/v4l/videocodec.c:381: error: implicit
declaration of function 'proc_create'
/home/david/Escritorio/v4l-dvb/v4l/videocodec.c:381: warning: assignment
makes pointer from integer without a cast
make[3]: *** [/home/david/Escritorio/v4l-dvb/v4l/videocodec.o] Error 1
make[2]: *** [_module_/home/david/Escritorio/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.24-16-generic'
make[1]: *** [default] Error 2
make[1]: se sale del directorio `/home/david/Escritorio/v4l-dvb/v4l'
make: *** [all] Error 2

I know little about programming in c., could be the problem some option of
the compiler?.

gcc version is 4.2.3

Thanks in advance.

------=_Part_3974_27729160.1209131867727
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,<br><br>I&#39;m a newbie in linux, recently i have updated to Ubuntu 8.04 and when i try to install v4l-dvb the script send me an error. <br><br>/home/david/Escritorio/v4l-dvb/v4l/videocodec.c: In function &#39;videocodec_init&#39;:<br>
/home/david/Escritorio/v4l-dvb/v4l/videocodec.c:381: error: implicit declaration of function &#39;proc_create&#39;<br>/home/david/Escritorio/v4l-dvb/v4l/videocodec.c:381: warning: assignment makes pointer from integer without a cast<br>
make[3]: *** [/home/david/Escritorio/v4l-dvb/v4l/videocodec.o] Error 1<br>make[2]: *** [_module_/home/david/Escritorio/v4l-dvb/v4l] Error 2<br>make[2]: Leaving directory `/usr/src/linux-headers-2.6.24-16-generic&#39;<br>make[1]: *** [default] Error 2<br>
make[1]: se sale del directorio `/home/david/Escritorio/v4l-dvb/v4l&#39;<br>make: *** [all] Error 2<br><br>I know little about programming in c., could be the problem some option of the compiler?. <br><br>gcc version is 4.2.3<br>
<br>Thanks in advance. <br><br>

------=_Part_3974_27729160.1209131867727--


--===============0715269809==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0715269809==--
