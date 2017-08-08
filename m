Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60868 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752014AbdHHN3A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 09:29:00 -0400
Date: Tue, 8 Aug 2017 16:28:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v1 2/2] [media] ov9655: fix missing mutex_destroy()
Message-ID: <20170808132857.of2isnqpnsjmlhol@valkosipuli.retiisi.org.uk>
References: <1500652181-971-1-git-send-email-hugues.fruchet@st.com>
 <1500652181-971-3-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1500652181-971-3-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 21, 2017 at 05:49:41PM +0200, Hugues Fruchet wrote:
> Fix missing mutex_destroy() when probe fails and
> when driver is removed.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>

Thanks, applied both, with the subject changed to reflect the driver file
name (ov9550.c).

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
