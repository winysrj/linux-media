Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43444 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752005AbaL3MiK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Dec 2014 07:38:10 -0500
Date: Tue, 30 Dec 2014 14:38:05 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Bin Chen <bin.chen@linaro.org>
Cc: linux-media@vger.kernel.org
Subject: Re: V4L2_CID_AUTO_FOCUS_START VS V4L2_CID_FOCUS_AUTO
Message-ID: <20141230123804.GL17565@valkosipuli.retiisi.org.uk>
References: <CANC6fRHnixRvs8ZOuCeMLaoAR1LOaExHxTBZqKy2qbEeWjmv4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANC6fRHnixRvs8ZOuCeMLaoAR1LOaExHxTBZqKy2qbEeWjmv4Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ben,

On Fri, Dec 19, 2014 at 11:48:58AM +0800, Bin Chen wrote:
> Hi,
> 
> Can anyone explain what is the difference between setting control
> V4L2_CID_FOCUS_AUTO to 1 and and issuing V4L2_CID_AUTO_FOCUS_START?
> Confused...

V4L2_CID_AUTO_FOCUS_START starts a single-pass AF algorithm which ends after
reaching focus (or failing in trying that), whereas enabling the
V4L2_CID_FOCUS_AUTO control enables a contiguous AF algorithm.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
