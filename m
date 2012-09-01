Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37299 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751761Ab2IAR1B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Sep 2012 13:27:01 -0400
Date: Sat, 1 Sep 2012 20:26:58 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH] [media] davinci: vpfe: Add documentation
Message-ID: <20120901172658.GB6757@valkosipuli.retiisi.org.uk>
References: <1342021166-6092-1-git-send-email-manjunath.hadli@ti.com>
 <20120802000756.GM26642@valkosipuli.retiisi.org.uk>
 <502331F8.3050503@ti.com>
 <20120816162318.GZ29636@valkosipuli.retiisi.org.uk>
 <50349ED2.4050209@ti.com>
 <20120901172530.GA6757@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120901172530.GA6757@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 01, 2012 at 08:25:30PM +0300, Sakari Ailus wrote:
> That would be against the V4L2 spec. It's explicitly defined that the source
> compose rectangle defines the output size of the scaler.

This should be sink, not source.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
