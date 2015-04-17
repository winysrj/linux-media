Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
MIME-Version: 1.0
Date: Fri, 17 Apr 2015 19:29:05 +0530
Message-ID: <CAPAqnGp0poptvEiMOk3oxs7=H8C5DOx-g0qpKZVQGQ_fa20-3Q@mail.gmail.com>
From: Mahesh Dl <dl.mahesh@gmail.com>
To: linux-dvb@linuxtv.org, mass@linuxtv.org
Subject: [linux-dvb] DSMCC-MHP-TOOLS incremental carousel updates
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0585239395=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0585239395==
Content-Type: multipart/alternative; boundary=001a1147f248c7c1cc0513ebfb98

--001a1147f248c7c1cc0513ebfb98
Content-Type: text/plain; charset=UTF-8

Hello Marek Pikarski,

First of all thank you for the dsmcc-mhp-tools, it made my test setup easy
for carousel's. It works flawless so far, i use tscbrmuxer from opencaster
for muxing with AV.

As of now, i  am confused on "updating of version number for the module,
once i update some files or folders in the carousel directory", i guess its
already included in the package as it is mentioned in the README that
incremental updates are supported. Please provide an example of command
usage to achieve this.

I use the inotify-tools to monitor the directory for carousel and can
generate the new m2t file when ever there is a change in the directory. The
command used to generate the m2t is  - dsmcc-oc --in=/home/root/dsmcc
--out=test4.m2t --pid=0x07d3 -cid 0x00000001 --tag=0xb -ns -v .

Please help.

Thanks & Regards,
Mahesh

--001a1147f248c7c1cc0513ebfb98
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello=C2=A0Marek Pikarski,<div><br></div><div>First of all=
 thank you for the dsmcc-mhp-tools, it made my test setup easy for carousel=
&#39;s. It works flawless so far, i use tscbrmuxer from opencaster for muxi=
ng with AV.</div><div><br></div><div>As of now, i =C2=A0am confused on &quo=
t;updating of version number for the module, once i update some files or fo=
lders in the carousel directory&quot;, i guess its already included in the =
package as it is mentioned in the README that incremental updates are suppo=
rted. Please provide an example of command usage to achieve this.</div><div=
><br></div><div>I use the inotify-tools to monitor the directory for carous=
el and can generate the new m2t file when ever there is a change in the dir=
ectory. The command used to generate the m2t is =C2=A0- dsmcc-oc --in=3D/ho=
me/root/dsmcc --out=3Dtest4.m2t --pid=3D0x07d3 -cid 0x00000001 --tag=3D0xb =
-ns -v .</div><div><br></div><div>Please help.</div><div><br></div><div>Tha=
nks &amp; Regards,</div><div>Mahesh</div></div>

--001a1147f248c7c1cc0513ebfb98--


--===============0585239395==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0585239395==--
