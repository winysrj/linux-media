Return-path: <mchehab@pedra>
Received: from yop.chewa.net ([91.121.105.214]:49891 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab1E1NBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 09:01:25 -0400
Received: from basile.remlab.net (cs27062010.pp.htv.fi [89.27.62.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: remi)
	by yop.chewa.net (Postfix) with ESMTPSA id 60429C8
	for <linux-media@vger.kernel.org>; Sat, 28 May 2011 15:01:24 +0200 (CEST)
From: "=?utf-8?q?R=C3=A9mi?= Denis-Courmont" <remi@remlab.net>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
Date: Sat, 28 May 2011 16:01:22 +0300
References: <4DDAC0C2.7090508@redhat.com> <4DDBD504.5020109@redhat.com> <4DE0EE44.8060000@infradead.org>
In-Reply-To: <4DE0EE44.8060000@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105281601.23130.remi@remlab.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Le samedi 28 mai 2011 15:44:52 Mauro Carvalho Chehab, vous avez écrit :
> > int libv4l2_get_associated_devive(int fd, enum
> > libv4l2_associated_device_types type, ...); Where fd is the fd of an
> > open /dev/video node, and ... is a param through which the device gets
> > returned (I guess a char * to a buffer of MAX_PATH length where the
> > device name gets stored, this could
> > be an also identifier like hw:0.0 or in case of vbi a /dev/vbi# path,
> > etc.
> 
> Using the fd will be more complex, as we'll loose the device node (is there
> a glibc way to get the device path from the fd?). Well, we may associate
> the fd descriptor with the device node internally at libv4l.

Not really. fstat() can tell you fd is a character device, and provide the 
major and minor though.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
