Return-path: <mchehab@pedra>
Received: from smtp1-g21.free.fr ([212.27.42.1]:33566 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758465Ab1F1S00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 14:26:26 -0400
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:8db5])
	by smtp1-g21.free.fr (Postfix) with ESMTP id E719B940144
	for <linux-media@vger.kernel.org>; Tue, 28 Jun 2011 20:26:18 +0200 (CEST)
Date: Tue, 28 Jun 2011 20:27:48 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCHv2 10/13] [media] gspca: don't include linux/version.h
Message-ID: <20110628202748.18a80567@tele>
In-Reply-To: <20110627231734.6b68b99c@pedra>
References: <cover.1309226359.git.mchehab@redhat.com>
 <20110627231734.6b68b99c@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 27 Jun 2011 23:17:34 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Instead of handling a per-driver driver version, use the
> per-subsystem one.
> 
> As reviewed by Jean-Francois Moine <moinejf@free.fr>:
> 	- the 'info' may be simplified:
> 
> Reviewed-by: Jean-Francois Moine <moinejf@free.fr>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Jean-Francois Moine <moinejf@free.fr>

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
