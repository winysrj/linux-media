Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:51192 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751642AbdK0TJq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 14:09:46 -0500
Date: Mon, 27 Nov 2017 19:09:38 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2 3/3] media: staging: atomisp: fixed some checkpatch
 integer type warnings.
Message-ID: <20171127190938.73c6b15a@alans-desktop>
In-Reply-To: <20171127124450.28799-4-jeremy@azazel.net>
References: <20171127122125.GB8561@kroah.com>
        <20171127124450.28799-1-jeremy@azazel.net>
        <20171127124450.28799-4-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 27 Nov 2017 12:44:50 +0000
Jeremy Sowden <jeremy@azazel.net> wrote:

> Changed the types of some arrays from int16_t to s16W


Which are the same type, except int16_t is the standard form.

No point.

Alan
