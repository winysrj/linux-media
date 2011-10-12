Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:40887 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1JLIcs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Oct 2011 04:32:48 -0400
Date: Wed, 12 Oct 2011 11:29:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	"Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, devel@driverdev.osuosl.org,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] Staging: cx25821: off by on in cx25821_vidioc_s_input()
Message-ID: <20111012082951.GF18470@longonot.mountain>
References: <20111007132643.GB31424@elgon.mountain>
 <4E94AE2D.4050408@redhat.com>
 <20111012081412.GE18470@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012081412.GE18470@longonot.mountain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Never mind.  I figured out what you meant.  I've fixed my patch and
I will send v2 this evening.

regards,
dan carpenter
