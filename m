Return-path: <mchehab@pedra>
Received: from mail.masin.eu ([80.188.199.19]:54870 "EHLO mail.masin.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756571Ab1AMLRy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 06:17:54 -0500
From: =?utf-8?Q?Radek_Ma=C5=A1=C3=ADn?= <radek@masin.eu>
Date: Thu, 13 Jan 2011 12:12:49 +0100
To: linux-media@vger.kernel.org
Message-ID: <1294917169022149500@masin.eu>
Subject: Logitech C910 camera problem
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,
I'm trying to get working two Logitech C910 cameras in one computer and I'm unable to
do it. I connect both cameras to one USB controller and first camera is starting capture
without problem, but when I try to start second camera during first camera is running, 
I get message in log "uvcvideo: Failed to submit URB 0" and capturing fails. 
I have discussed this problem on quickcamteam forum and it seems, that there is problem
with uvcvideo driver for this camera. 

Thank you
Radek Masin
