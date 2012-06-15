Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814Ab2FON0m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 09:26:42 -0400
Date: Fri, 15 Jun 2012 09:26:17 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Ben Hutchings <ben@decadent.org.uk>,
	Luis Henriques <luis.henriques@canonical.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 5/8] nuvoton-cir: Code cleanup: remove unused variable
 and function
Message-ID: <20120615132617.GB32380@redhat.com>
References: <1339696716-14373-1-git-send-email-peter.senna@gmail.com>
 <1339696716-14373-5-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339696716-14373-5-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 14, 2012 at 02:58:13PM -0300, Peter Senna Tschudin wrote:
> Tested by compilation only.

Making use of this code is on the TODO list, possibly even happens by way
of David's pending patches for lirc interface parity, so I'm against
removing it.

-- 
Jarod Wilson
jarod@redhat.com

