Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:26731 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab3BFJuA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 04:50:00 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: Federico Vaga <federico.vaga@gmail.com>
Subject: Re: [PATCH v6 1/2] sta2x11_vip: convert to videobuf2, control framework, file handler
Date: Wed, 6 Feb 2013 10:49:10 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201302041157.45340.hverkuil@xs4all.nl> <1360089277-27898-1-git-send-email-federico.vaga@gmail.com>
In-Reply-To: <1360089277-27898-1-git-send-email-federico.vaga@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302061049.10879.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Federico,

OK, I'm going to give this my Acked-by, but I really wish you would have split
this up into smaller changes. It's hard to review since you have made so many
changes in this one patch. Even though I'm giving my ack, Mauro might decide
against it, so if you have time to spread out the changes in multiple patches,
then please do so.

So, given the fact that this changes just a single driver not commonly used in
existing deployments, assuming that you have tested the changes (you did that,
right? Just checking...), that these are really useful improvements, and that
I reviewed the code (as well as I could) and didn't see any problems, I'm
giving my ack anyway:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
