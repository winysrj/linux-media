Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:32844 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753806AbdCTLTY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 07:19:24 -0400
Received: by mail-wr0-f194.google.com with SMTP id g10so17628425wrg.0
        for <linux-media@vger.kernel.org>; Mon, 20 Mar 2017 04:19:23 -0700 (PDT)
Received: from macbox (ip-37-24-178-151.hsi14.unitymediagroup.de. [37.24.178.151])
        by smtp.gmail.com with ESMTPSA id k128sm13058278wmf.16.2017.03.20.04.10.21
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Mar 2017 04:10:21 -0700 (PDT)
Date: Mon, 20 Mar 2017 12:10:14 +0100
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 11/13] [media] dvb-frontends/stv0367: add Digital
 Devices compatibility
Message-ID: <20170320121014.4357d500@macbox>
In-Reply-To: <20170307185727.564-12-d.scheller.oss@gmail.com>
References: <20170307185727.564-1-d.scheller.oss@gmail.com>
        <20170307185727.564-12-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Tue,  7 Mar 2017 19:57:25 +0100
schrieb Daniel Scheller <d.scheller.oss@gmail.com>:

> - add a third *_attach function which will make use of a third
> frontend_ops struct which announces both -C and -T support (the same
> as with DD's own driver stv0367dd). This is necessary to support both
> delivery systems on one FE without having to do large conversions to
> VB2 or the need to select either -C or -T mode via modparams and the
> like. Additionally, the frontend_ops point to new "glue" functions
> which will then call into the existing functionality depending on the
> active delivery system/demod state (all used functionality works
> almost OOTB).

In the meantime I realised that stv0367ddb_ops is missing symbolrate
limits which w_scan complains about. Will be added in a V2 series.

Daniel
