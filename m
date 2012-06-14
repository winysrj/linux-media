Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50326 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756085Ab2FNTC1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 15:02:27 -0400
Date: Thu, 14 Jun 2012 20:02:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jarod Wilson <jarod@redhat.com>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Luis Henriques <luis.henriques@canonical.com>,
	linux-media@vger.kernel.org
Message-ID: <20120614190219.GK2753@decadent.org.uk>
References: <1339696716-14373-1-git-send-email-peter.senna@gmail.com>
 <1339696716-14373-5-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339696716-14373-5-git-send-email-peter.senna@gmail.com>
Subject: Re: [PATCH 5/8] nuvoton-cir: Code cleanup: remove unused variable
 and function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 14, 2012 at 02:58:13PM -0300, Peter Senna Tschudin wrote:
> Tested by compilation only.
[...]

I can't say whether this is correct since I never used the driver
either, but the function you remove is reading registers so it may
have important side-effects.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
