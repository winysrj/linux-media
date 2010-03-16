Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:63476 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab0CPTaP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Mar 2010 15:30:15 -0400
Received: by fxm19 with SMTP id 19so314637fxm.21
        for <linux-media@vger.kernel.org>; Tue, 16 Mar 2010 12:30:14 -0700 (PDT)
Message-ID: <4B9FDC37.8000806@googlemail.com>
Date: Tue, 16 Mar 2010 20:29:59 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: changeset 14351:2eda2bcc8d6f
References: <4B8E4A6F.2050809@googlemail.com> <201003131727.06450.hverkuil@xs4all.nl>
In-Reply-To: <201003131727.06450.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.3.2010 17:27, schrieb Hans Verkuil:
> If there are no further comments, then I'll post a pull request in a few days.
> 
> Tested with the mxb board. It would be nice if you can verify this with the
> av7110.

Hi hans,

it works with my TT-C2300 perfectly. The main problem of your changes was: It wasn't
possible to unload the module for the TT-C2300.

Regards,
Hartmut
