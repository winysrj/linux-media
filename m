Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:51166 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755431Ab1CVMZ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 08:25:29 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Tue, 22 Mar 2011 17:55:13 +0530
Subject: RE: [PATCH v17 10/13] davinci: dm644x: change vpfe capture
 structure variables for consistency
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024C47D7B8@dbde02.ent.ti.com>
References: <1300197552-4780-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1300197552-4780-1-git-send-email-manjunath.hadli@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 15, 2011 at 19:29:12, Hadli, Manjunath wrote:
> change the vpfe capture related configuration structure variables from
> <config> to dm644xevm_<config> to make it consistent with the rest of
> the file.

This description is not fully accurate. You also have changes
where you add SoC prefix to variable names. I guess you can just
say "Add SoC and board prefixes to variable names so that.."

Thanks,
Sekhar

