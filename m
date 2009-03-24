Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45143 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbZCXXOU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 19:14:20 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"stoyboyker@gmail.com" <stoyboyker@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 24 Mar 2009 18:14:12 -0500
Subject: RE: [PATCH 12/13][Resubmit][drivers/media] changed ioctls to
 unlocked
Message-ID: <A24693684029E5489D1D202277BE89442E804BDD@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89442E804BDB@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> >  {
> > +	lock_kernel();
> > +
> 
> Why moving to unlocked_ioctl if you're acquiring the Big Kernel Lock
> anyways?

Ok, forget it, just saw Alexey mail chain...

Understood.

Regards,
Sergio
