Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab0GDPbb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Jul 2010 11:31:31 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o64FVUMA015008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 4 Jul 2010 11:31:30 -0400
Message-ID: <4C30A950.1080605@redhat.com>
Date: Sun, 04 Jul 2010 12:31:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/3] IR/lirc: add docbook info covering lirc device interface
References: <20100601205005.GA28322@redhat.com> <20100703040530.GB31255@redhat.com> <20100703041009.GF31255@redhat.com>
In-Reply-To: <20100703041009.GF31255@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-07-2010 01:10, Jarod Wilson escreveu:
> First ever crack at creating docbook documentation... Contains a bevy of
> information on the various lirc device interface ioctls, as well as a
> bit about the read and write interfaces.

I found a few errors on it when adding at the media DocBook. Nothing serious. 
I fixed the errors, and added it there. Now, "make htmldocs" will compile and
add the proper LIRC section at the specs.

Please review and double check if everything is ok.

Currently, it lacks several details, like the flags used on GET_FEATURES, and
a better description about LIRC_MODE_*, so I'm waiting for more patches to 
improve the spec ;)

Anyway, merged, together with the 3 other LIRC patches.

Cheers,
Mauro.
