Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@graeber-clan.de>) id 1KmwVM-0003gm-9K
	for linux-dvb@linuxtv.org; Mon, 06 Oct 2008 22:16:32 +0200
Received: from wega.graeber.private (i53872A6B.versanet.de [83.135.42.107])
	by post.webmailer.de (klopstock mo45) (RZmta 17.10)
	with EDH-RSA-DES-CBC3-SHA encrypted ESMTP id 60026ak96IabkJ
	for <linux-dvb@linuxtv.org>; Mon, 6 Oct 2008 22:16:28 +0200 (MEST)
	(envelope-from: <lists@graeber-clan.de>)
Received: from localhost (localhost [127.0.0.1])
	by wega.graeber.private (Postfix) with ESMTP id 548E664002
	for <linux-dvb@linuxtv.org>; Mon,  6 Oct 2008 22:16:28 +0200 (CEST)
Received: from wega.graeber.private ([127.0.0.1])
	by localhost (wega.graeber.private [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id a9fqR+apJxzF for <linux-dvb@linuxtv.org>;
	Mon,  6 Oct 2008 22:16:26 +0200 (CEST)
Received: from sirius.localnet (sirius.local [192.168.42.2])
	by wega.graeber.private (Postfix) with ESMTPS id 695C064001
	for <linux-dvb@linuxtv.org>; Mon,  6 Oct 2008 22:16:26 +0200 (CEST)
From: Herbert Graeber <lists@graeber-clan.de>
To: linux-dvb@linuxtv.org
Date: Mon, 6 Oct 2008 22:16:16 +0200
MIME-Version: 1.0
Message-Id: <200810062216.18729.lists@graeber-clan.de>
Subject: [linux-dvb] MSI Digi Vox mini III
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0525552186=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0525552186==
Content-Type: multipart/alternative;
  boundary="Boundary-00=_SIn6Irp46JlA3fI"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-00=_SIn6Irp46JlA3fI
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Current linux dvb doesn't support the MSI Digi VOX mini III DVB-T usb stick 
(1462:8807).

I have got the af9015 driver from the mercurial repository 
http://linuxtv.org/hg/~anttip/af9015, added the USB ID mentioned above to the 
file af9015/linux/drivers/media/dvb/dvb-usb/af9015.c  and then the DVB-T stick 
works fine.

Cheers,
Herbert

--Boundary-00=_SIn6Irp46JlA3fI
Content-Type: text/html;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">
<html><head><meta name="qrichtext" content="1" /><style type="text/css">
p, li { white-space: pre-wrap; }
</style></head><body style=" font-family:'DejaVu Sans'; font-size:10pt; font-weight:400; font-style:normal;">
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Current linux dvb doesn't support the MSI Digi VOX mini III DVB-T usb stick (1462:8807).</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">I have got the af9015 driver from the mercurial repository http://linuxtv.org/hg/~anttip/af9015, added the USB ID mentioned above to the file af9015/linux/drivers/media/dvb/dvb-usb/af9015.c  and then the DVB-T stick works fine.</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Cheers,</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Herbert</p></body></html>
--Boundary-00=_SIn6Irp46JlA3fI--


--===============0525552186==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0525552186==--
