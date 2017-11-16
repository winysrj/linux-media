Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52324 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934929AbdKPRLX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 12:11:23 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vAGH8g65092391
        for <linux-media@vger.kernel.org>; Thu, 16 Nov 2017 12:11:22 -0500
Received: from e06smtp14.uk.ibm.com (e06smtp14.uk.ibm.com [195.75.94.110])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2e9csc796b-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Thu, 16 Nov 2017 12:11:22 -0500
Received: from localhost
        by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Thu, 16 Nov 2017 17:11:20 -0000
Subject: Re: [PATCH 0/4] treewide: Fix line continuation formats
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-pm@vger.kernel.org,
        linux-integrity@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-security-module@vger.kernel.org
Date: Thu, 16 Nov 2017 12:11:13 -0500
In-Reply-To: <cover.1510845910.git.joe@perches.com>
References: <cover.1510845910.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <1510852273.3711.448.camel@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-11-16 at 07:27 -0800, Joe Perches wrote:
> Avoid using line continations in formats as that causes unexpected
> output.

Is having lines greater than 80 characters the preferred method?
 Could you add quotes before the backlash and before the first word on
the next line instead?

Mimi
