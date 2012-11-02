Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64791 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab2KBHfu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2012 03:35:50 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so4676640iea.19
        for <linux-media@vger.kernel.org>; Fri, 02 Nov 2012 00:35:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1351773720-22639-1-git-send-email-elezegarcia@gmail.com>
References: <1351773720-22639-1-git-send-email-elezegarcia@gmail.com>
Date: Fri, 2 Nov 2012 08:35:49 +0100
Message-ID: <CA+6av4nv=J7wZKKbKVSGyNRVaZUO24Qv8NwbbCK8v_ZrU-7oUQ@mail.gmail.com>
Subject: Re: [PATCH] stkwebcam: Fix sparse warning on undeclared symbol
From: Arvydas Sidorenko <asido4@gmail.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media@vger.kernel.org,
	Andrea Anacleto <andreaanacleto@libero.it>,
	Jaime Velasco Juan <jsagarribay@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> why the heck do we need this first_init?

first_init was introduced in 7b1c8f58fcdbed75 for turning off LED when
the cam finishes
the capture.
Andrea Anacleto <andreaanacleto@libero.it> claimed that the change
broke his webcam
on the same laptop, so he introduced that variable to fix the issue.
It didn't have any
impact to my cam so I merged it's patch and resent my fix to the maintainer.
