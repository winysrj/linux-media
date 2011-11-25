Return-path: <linux-media-owner@vger.kernel.org>
Received: from yop.chewa.net ([91.121.105.214]:52795 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab1KYNeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 08:34:09 -0500
From: "=?iso-8859-15?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: gnutv should not ignore SIGPIPE
Date: Fri, 25 Nov 2011 15:34:04 +0200
Cc: linux-media@vger.kernel.org
References: <jao3r9$i9e$1@dough.gmane.org>
In-Reply-To: <jao3r9$i9e$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201111251534.05480.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le vendredi 25 novembre 2011 15:05:44 Brian J. Murrell, vous avez écrit :
> Is there a good reason I am not seeing why gnutv should be ignoring
> SIGPIPE?

In general, ignoring SIGPIPE is the easiest way to protect against denial of 
service when a peer connection socket is hung up remotely. MSG_NOSIGNAL is a 
more modern alternative.

Anyway, the problem is not so mucgh ignoring SIGPIPE as ignoring EPIPE write 
errors.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
