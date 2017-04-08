Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:39292 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752406AbdDHRXa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 8 Apr 2017 13:23:30 -0400
Date: Sat, 8 Apr 2017 11:23:28 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 00/21] Convert USB documentation to ReST format
Message-ID: <20170408112328.7cc07f53@lwn.net>
In-Reply-To: <cover.1491398120.git.mchehab@s-opensource.com>
References: <cover.1491398120.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed,  5 Apr 2017 10:22:54 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> Currently, there are several USB core documents that are at either
> written in plain text or in DocBook format. Convert them to ReST
> and add to the driver-api book.

Greg, do you see any reason not to apply these for 4.12?  A few of them
touch comments outside of Documentation/; I'm happy to carry those or
leave them to you, as you prefer.

Thanks,

jon
