Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57509 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754690AbcHSDaj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:30:39 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>
Subject: [PATCH 14/20] [media] docs-rst: re-generate vbi_525.pdf and vbi_625.pdf
Date: Thu, 18 Aug 2016 13:15:43 -0300
Message-Id: <87924f9648e127e68eec879ab6c4c5d96a645913.1471532123.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Originally, each image were one page big, causing them to be
displayed on separate pages at the PDF output. Re-generate
them from the gif files.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/v4l/dev-raw-vbi_files/vbi_525.pdf      | Bin 3395 -> 3706 bytes
 .../media/uapi/v4l/dev-raw-vbi_files/vbi_625.pdf      | Bin 3683 -> 3996 bytes
 2 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_525.pdf b/Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_525.pdf
index 9e72c25b208db6c7844ed85fe9742324602c0a5c..0bae28385dfa119b6d3718e2e6cf6dc411ad0f67 100644
GIT binary patch
literal 3706
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

literal 3395
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

diff --git a/Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_625.pdf b/Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_625.pdf
index 765235e33a4de256a0b3fbf64ffe52946190cac4..bf29b95dcd0800b4f7d05389ad60cf3e82569b00 100644
GIT binary patch
literal 3996
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

literal 3683
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
O%*+C6V6bby1N2|1C{8y3

-- 
2.7.4


