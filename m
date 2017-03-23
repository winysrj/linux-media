Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:52428 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965368AbdCWQAL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Mar 2017 12:00:11 -0400
Message-ID: <1490284791.5934.45.camel@linux.intel.com>
Subject: Re: [PATCH] staging: media: atomisp: fix build error
From: Alan Cox <alan@linux.intel.com>
To: Geliang Tang <geliangtang@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?ISO-8859-1?Q?J=E9r=E9my?= Lefaure <jeremy.lefaure@lse.epita.fr>,
        Varsha Rao <rvarsha016@gmail.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 23 Mar 2017 15:59:51 +0000
In-Reply-To: <328d0eb3da461aaaa6140b1409ee7550bcec87bb.1490261279.git.geliangtang@gmail.com>
References: <328d0eb3da461aaaa6140b1409ee7550bcec87bb.1490261279.git.geliangtang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-03-23 at 21:12 +0800, Geliang Tang wrote:
> Fix the following build error:
> 
>   CC      drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.o
> drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c:52:2:
>  error: excess elements in array initializer [-Werror]
>   "i", /* ion */
>   ^~~

NAK

I've sent a patch to sort this out properly we shouldn't be using
string arrays for single char values to start with...

Alan
