Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:60765 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab1CVNPS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 09:15:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v17 08/13] davinci: eliminate use of IO_ADDRESS() on sysmod
Date: Tue, 22 Mar 2011 14:15:03 +0100
Cc: "Nori, Sekhar" <nsekhar@ti.com>,
	"Hadli, Manjunath" <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1300197523-4574-1-git-send-email-manjunath.hadli@ti.com> <B85A65D85D7EB246BE421B3FB0FBB593024C47D7B5@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024C47D7B5@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103221415.03904.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 22 March 2011, Nori, Sekhar wrote:
> .. but forgot to fix this. There is nothing wrong with
> using writel, but it doesn't fit into what the subject
> of this patch is.

Well, to be more exact, the __raw_writel was actually
wrong here and it should be writel(), but it's certainly
better to mention the reason in the changelog, or to
make a separate patch for it.

	Arnd
