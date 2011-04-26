Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <lists.pascal.juergens@googlemail.com>)
	id 1QEorU-0007jV-Si
	for linux-dvb@linuxtv.org; Tue, 26 Apr 2011 22:27:58 +0200
Received: from mail-wy0-f182.google.com ([74.125.82.182])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-2) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1QEorU-00059L-Gk; Tue, 26 Apr 2011 22:27:56 +0200
Received: by wyf23 with SMTP id 23so1064147wyf.41
	for <linux-dvb@linuxtv.org>; Tue, 26 Apr 2011 13:27:55 -0700 (PDT)
References: <BANLkTimGx15EGwbsafJA81m1anbRw+AV2A@mail.gmail.com>
From: =?utf-8?Q?Pascal_J=C3=BCrgens?= <lists.pascal.juergens@googlemail.com>
In-Reply-To: <BANLkTimGx15EGwbsafJA81m1anbRw+AV2A@mail.gmail.com>
Message-Id: <EE21DCB3-587C-465C-B371-CA508CB2DCEC@googlemail.com>
Date: Tue, 26 Apr 2011 22:28:38 +0200
Cc: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Mime-Version: 1.0 (iPad Mail 8H7)
Subject: Re: [linux-dvb] analog OTA tuning
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1823627538=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>


--===============1823627538==
Content-Type: multipart/alternative;
	boundary=Apple-Mail-2--874993763
Content-Transfer-Encoding: 7bit


--Apple-Mail-2--874993763
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

That info might be stale, but the last time I looked at the v4l device wiki,=
 it said that the analog tuner of these cards is not yet supported in Linux.=
=20

Cheers,
Pascal

On 26.04.2011, at 22:08, Martin Cole <mjcoogle@gmail.com> wrote:

>=20
> Hi,
>=20
> I need to tune analog OTA channels from a pci-e card.  I bought the follow=
ing card:
>=20
> http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-2200  (I actually ha=
ve the 2250)
>=20
> after installing and downloading the firmware etc, this works fine when tu=
ning the digital OTA signal that I can see locally.
>=20
> I am unsure how to change the frontend to attempt to tune analog tv input o=
r even if this is supported, can someone point me in the right direction to d=
o this? It looks like I would need to change the tuner type in the driver co=
de (if analog is supported)
>=20
> I am aware that no analog broadcasts exist anymore in the US, but where th=
is will eventually be used still has analog OTA broadcasts.
> My test setup for now includes a digital to analog converter, which i woul=
d like to tune with this card, once this works I would test with the actual O=
TA signal.
>=20
> Looking at the tuner chip on the card, suggests that it is possible. The l=
ink on the wiki for the chip is outdated it seems, this is what I found on t=
he nxp site:
>=20
> http://www.nxp.com/#/pip/pip=3D[pip=3DTDA18271HD]|pp=3D[t=3Dpip,i=3DTDA182=
71HD]
>=20
> I am happy to dive into the code, but wanted to see if anyone has done thi=
s already or get any suggestions that you more experienced developers could p=
rovide.
>=20
> Thanks,
> --mc
>=20
>=20
>=20
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

--Apple-Mail-2--874993763
Content-Transfer-Encoding: 7bit
Content-Type: text/html;
	charset=utf-8

<html><body bgcolor="#FFFFFF"><div><div>That info might be stale, but the last time I looked at the v4l device wiki, it said that the analog tuner of these cards is not yet supported in Linux.&nbsp;<br><br></div><div>Cheers,<br>Pascal</div><div><br>On 26.04.2011, at 22:08, Martin Cole &lt;<a href="mailto:mjcoogle@gmail.com"><a href="mailto:mjcoogle@gmail.com">mjcoogle@gmail.com</a></a>&gt; wrote:<br><br></div><div></div><blockquote type="cite"><div><br>Hi,<br><br>I need to tune analog OTA channels from a pci-e card.&nbsp; I bought the following card:<br><br><a href="http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-2200"></a><a href="http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-2200"><a href="http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-2200">http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-2200</a></a>&nbsp; (I actually have the 2250)<br>
<br>after installing and downloading the firmware etc, this works fine when tuning the digital OTA signal that I can see locally.<br><br>I am unsure how to change the frontend to attempt to tune analog tv input or even if this is supported, can someone point me in the right direction to do this? It looks like I would need to change the tuner type in the driver code (if analog is supported)<br>
<br>I am aware that no analog broadcasts exist anymore in the US, but where this will eventually be used still has analog OTA broadcasts.<br>My test setup for now includes a digital to analog converter, which i would like to tune with this card, once this works I would test with the actual OTA signal.<br>
<br>Looking at the tuner chip on the card, suggests that it is possible. The link on the wiki for the chip is outdated it seems, this is what I found on the nxp site:<br><br><a href="http://www.nxp.com/#/pip/pip=[pip=TDA18271HD]|pp=[t=pip,i=TDA18271HD]"></a><a href="http://www.nxp.com/#/pip/pip=[pip=TDA18271HD]|pp=[t=pip,i=TDA18271HD]"><a href="http://www.nxp.com/#/pip/pip=[pip=TDA18271HD]|pp=[t=pip,i=TDA18271HD]">http://www.nxp.com/#/pip/pip=[pip=TDA18271HD]|pp=[t=pip,i=TDA18271HD]</a></a><br>
<br>I am happy to dive into the code, but wanted to see if anyone has done this already or get any suggestions that you more experienced developers could provide.<br><br>Thanks,<br>--mc<br><br><br><br>
</div></blockquote><blockquote type="cite"><div><span>_______________________________________________</span><br><span>linux-dvb users mailing list</span><br><span>For V4L/DVB development, please use instead <a href="mailto:linux-media@vger.kernel.org"></a><a href="mailto:linux-media@vger.kernel.org"><a href="mailto:linux-media@vger.kernel.org">linux-media@vger.kernel.org</a></a></span><br><span><a href="mailto:linux-dvb@linuxtv.org"><a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a></a></span><br><span><a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb"><a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></a></span></div></blockquote></div></body></html>
--Apple-Mail-2--874993763--


--===============1823627538==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1823627538==--
