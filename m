Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3652CC43444
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 09:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06120206B6
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 09:58:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="UruqTDwt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbfAJJ63 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 04:58:29 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:39579 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727825AbfAJJ63 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 04:58:29 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20190110095825epoutp01176f68009949863b5e17fb3f0d17ddac~4dEOZlFD83218732187epoutp01T;
        Thu, 10 Jan 2019 09:58:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20190110095825epoutp01176f68009949863b5e17fb3f0d17ddac~4dEOZlFD83218732187epoutp01T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1547114305;
        bh=x5QnG5QWV4ikDkyVvItuyikbiv+1Rm7pJ0zkHbIZ7WU=;
        h=Subject:To:Cc:From:Date:In-reply-to:References:From;
        b=UruqTDwtQxThsCLBdx0WbAxZyQ8XYQC01dosn8dVKi2UhDrYORs5M6eQrOw/09izL
         kyEG8T1SuykcSDZvABRWSyFP5nO5S7hLhVNtOrV41dKK1edSBlKHFcGgjn1Zb9Bg3r
         diCAuLvmN/rUQrtF3ckjjTD99t20rC/rytn1Gqus=
Received: from epsmges2p4.samsung.com (unknown [182.195.42.72]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20190110095824epcas2p4668cebecc31b71483dad197f278445ad~4dENT7adq0371003710epcas2p4R;
        Thu, 10 Jan 2019 09:58:24 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        FD.A2.04055.047173C5; Thu, 10 Jan 2019 18:58:24 +0900 (KST)
Received: from epsmgms2p2new.samsung.com (unknown [182.195.42.143]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20190110095823epcas2p1936a8d201409b837f9cbd12497fb0e25~4dEMX922X2503425034epcas2p1a;
        Thu, 10 Jan 2019 09:58:23 +0000 (GMT)
X-AuditID: b6c32a48-3c1ff70000000fd7-90-5c3717405503
Received: from epmmp2 ( [203.254.227.17]) by epsmgms2p2new.samsung.com
        (Symantec Messaging Gateway) with SMTP id 09.36.03627.F37173C5; Thu, 10 Jan
        2019 18:58:23 +0900 (KST)
MIME-version: 1.0
Content-type: text/plain; charset="utf-8"
Received: from [106.116.147.40] by mmp2.samsung.com (Oracle Communications
        Messaging Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PL40086D118YF10@mmp2.samsung.com>; Thu, 10 Jan 2019 18:58:23 +0900 (KST)
Subject: Re: [PATCH] media: s5p-jpeg: Correct step and max values for
 V4L2_CID_JPEG_RESTART_INTERVAL
To:     =?UTF-8?Q?Pawe=c5=82_Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
Cc:     jacek.anaszewski@gmail.com, mchehab@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
From:   Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <146706fc-007a-c4f9-7ecf-b1bd893bb79d@samsung.com>
Date:   Thu, 10 Jan 2019 10:58:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.2.1
In-reply-to: <20190109180041.31052-1-pawel.mikolaj.chmiel@gmail.com>
Content-language: en-GB
Content-transfer-encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsWy7bCmua6DuHmMwayvkha3t25gsdj0+Bqr
        xeVdc9gsejZsZbWYcX4fk8WyTX+YLH4c72N2YPfYOesuu8emVZ1sHpuX1Ht83iQXwBLFZZOS
        mpNZllqkb5fAlXHhomDBKZaKVZvnszYwvmXuYuTkkBAwkbjcO5+1i5GLQ0hgB6PEz6aNTBDO
        d0aJNXM3sHQxcoBV7Z+QCdIgJLCBUeJRoziIzSsgKPFj8j0WEJtZQFPixZdJLBA19xklnlxV
        AbGFBdIkLt2dAbZMRMBJonfrK2aQ+cwCu4Bqvv0Da2ATMJToPdrHCDHUTuLp3u9MIHtZBFQl
        PnyrAgmLCkRIdNxfzQYS5hRwkbjzthxirbjEsfs3GSFseYmDV56zQPx1hk1i3iFrCNtForfn
        BBOELSzx6vgWdghbWuLZqo2MEHa1xK7t3WCnSQh0MEq0XNgODSBricPHL7JCLOCT6Dj8lx0S
        JLwSHW1CECUeEluXLmSHBNt0RomlV0+xTGCUnYUURLOQgmgWkrtnIbl7ASPLKkax1ILi3PTU
        YqMCE73ixNzi0rx0veT83E2M4ESh5bGD8cA5n0OMAhyMSjy8CsvNYoRYE8uKK3MPMUpwMCuJ
        8N4BCfGmJFZWpRblxxeV5qQWH2KU5mBREud9KD03WkggPbEkNTs1tSC1CCbLxMEp1cBooefB
        zlJTs3BH1667wW/zmucEyakc1nSrNb1X0Dn9pFJ1/RcHRl6+fHVD85yq0gPPTyxuXnTLQjvf
        WE/ywsuA6/bO/6ae6H4QNI//ZcmlcteuKWvLZtg0Vu7msQ/bt/RH6tyWybE5u6e9MU7c8/Wg
        Yl360bD7Qsu6M60zv/Lfi7/JohifE6bEUpyRaKjFXFScCADxK3mjEAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t9jQV17cfMYg0e9sha3t25gsdj0+Bqr
        xeVdc9gsejZsZbWYcX4fk8WyTX+YLH4c72N2YPfYOesuu8emVZ1sHpuX1Ht83iQXwBLFZZOS
        mpNZllqkb5fAlXHhomDBKZaKVZvnszYwvmXuYuTgkBAwkdg/IbOLkYtDSGAdo8Sb6ZdYuxg5
        OXgFBCV+TL7HAlLDLKAuMWVKLkTNQ0aJGfcns4HUCAukSVy6O4MZxBYRcJLo3fqKGaSIWWAX
        o8TlM5/BEkICzhKb521jArHZBAwleo/2MUIssJN4uvc7E8gCFgFViQ/fqkDCogIREmdfrmME
        CXMKuEjceVsOEmYWEJc4dv8mI4QtL3HwynOWCYwCs5BcOgvh0llIOmYh6VjAyLKKUTK1oDg3
        PbfYqMAoL7Vcrzgxt7g0L10vOT93EyMw4Lcd1urfwfh4SfwhRgEORiUe3oR/pjFCrIllxZW5
        hxglOJiVRHjvLDeLEeJNSaysSi3Kjy8qzUktPsQozcGiJM7Ln38sUkggPbEkNTs1tSC1CCbL
        xMEp1cA437vmM4dswOepDKbz+xM29XXuPNn1SrVK6eYEyb5He9P1/prM3vC/+42F+sxVql2O
        7TMMnXwcVDNDpec93v1tBZ+5j+Q3S01eiyN7Vl1q73+W8vrA+0vsqed23yoqvdv6R1/6qKWj
        8i/bcw8s3QQ/BjqscDY3qnQVv9gYvnaixeGpcWJpptxKLMUZiYZazEXFiQCT4vQudAIAAA==
X-CMS-MailID: 20190110095823epcas2p1936a8d201409b837f9cbd12497fb0e25
X-Msg-Generator: CA
CMS-TYPE: 102P
X-CMS-RootMailID: 20190110095823epcas2p1936a8d201409b837f9cbd12497fb0e25
References: <20190109180041.31052-1-pawel.mikolaj.chmiel@gmail.com>
        <CGME20190110095823epcas2p1936a8d201409b837f9cbd12497fb0e25@epcas2p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/9/19 19:00, Paweł Chmiel wrote:
> This commit corrects max and step values for v4l2 control for
> V4L2_CID_JPEG_RESTART_INTERVAL. Max should be 0xffff and step should be 1.
> It was found by using v4l2-compliance tool and checking result of
> VIDIOC_QUERY_EXT_CTRL/QUERYMENU test.
> Previously it was complaining that step was bigger than difference
> between max and min.
> 
> Fixes: 15f4bc3b1f42 ("[media] s5p-jpeg: Add JPEG controls support")
> Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
