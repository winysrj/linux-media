Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:55567 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756926Ab2IDM0b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2012 08:26:31 -0400
Received: from leon.localnet (unknown [IPv6:2001:660:330f:38:219:d2ff:fe07:5de5])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: remi)
	by oyp.chewa.net (Postfix) with ESMTPSA id 015D52024C
	for <linux-media@vger.kernel.org>; Tue,  4 Sep 2012 14:26:30 +0200 (CEST)
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: Re: RFC: use of timestamp/sequence in v4l2_buffer
Date: Tue, 4 Sep 2012 15:26:49 +0300
References: <201209041238.07000.hverkuil@xs4all.nl>
In-Reply-To: <201209041238.07000.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201209041526.49196@leon.remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mardi 4 septembre 2012 13:38:06, Hans Verkuil a écrit :
> 7) Should the timestamp field always be monotonically increasing? Or it is
> possible to get timestamps that jump around? This makes sense for encoders
> that create B-frames referring to frames captured earlier than an I-frame.

I would expect an encoder to output frames in DTS order rather than PTS and a 
decoder to output frames in PTS order. The timestamp field is the only 
indication of the PCR, so an application might not recover if the timestamp 
jumps backward.

If there is an ambiguity between PTS and DTS, I think it should be documented 
and specified per format what the timestamp is.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
