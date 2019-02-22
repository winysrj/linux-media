Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971C6C10F00
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 07:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C9072086D
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 07:02:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aHKBTdkm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbfBVHCB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 02:02:01 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52406 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbfBVHCB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 02:02:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1M6x0K7183184;
        Fri, 22 Feb 2019 07:01:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=o310/w5axxiuGS7FSxG/1eFBZdxhBHN1zeBeY+p75xI=;
 b=aHKBTdkmEs8HX0uvSlHXU9MyH0R5D6uTdmHMXSl1ehs1U0yLOakDWiEAkmb7Ww0wFzXr
 7mw1kc88kj5ypi/jgxMVm6lOyqpeHmfGK9oyYphTS6hBDje0QzZKF1jOxEmVgFCY2VFp
 bAkVFbqfs8C2WdHurbR+Tltn7FDiFTspLFDJP7N3PegV6IeOwK4al51leV4pf0rF6y8l
 bunLVBFpAXXuIh7bljNtW+ct71yi1km1Gk0DzjrH6TUATVSQ9OuYGB9n9/m3YwI0F+A1
 oXueYLL3TckBu5SMy4bA2XB7HRCtXatN9YTe5ASfwUALQ6sfLNoyEYj+TMmpXVNPovCV Zg== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2qpb5rvfax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Feb 2019 07:01:55 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1M71tw1014072
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Feb 2019 07:01:55 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1M71s66020791;
        Fri, 22 Feb 2019 07:01:54 GMT
Received: from kadam (/197.157.0.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Feb 2019 23:01:53 -0800
Date:   Fri, 22 Feb 2019 10:01:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@01.org, Rui Miguel Silva <rui.silva@linaro.org>
Cc:     kbuild-all@01.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [linux-next:master 8840/10202]
 drivers/staging/media/imx/imx7-media-csi.c:1082 imx7_csi_set_fmt() error:
 uninitialized symbol 'cc'.
Message-ID: <20190222070143.GF1711@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9174 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=795 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902220048
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   550f4769c7c4a84e3966f20887c6e249c5f2afc4
commit: 05f634040c0d05f59f2dcd39722157cb3b57c85b [8840/10202] media: staging/imx7: add imx7 CSI subdev driver

New smatch warnings:
drivers/staging/media/imx/imx7-media-csi.c:1082 imx7_csi_set_fmt() error: uninitialized symbol 'cc'.

Old smatch warnings:
drivers/staging/media/imx/imx7-media-csi.c:1076 imx7_csi_set_fmt() error: uninitialized symbol 'outcc'.

# https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=05f634040c0d05f59f2dcd39722157cb3b57c85b
git remote add linux-next https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
git remote update linux-next
git checkout 05f634040c0d05f59f2dcd39722157cb3b57c85b
vim +/cc +1082 drivers/staging/media/imx/imx7-media-csi.c

05f63404 Rui Miguel Silva 2019-02-06  1029  
05f63404 Rui Miguel Silva 2019-02-06  1030  static int imx7_csi_set_fmt(struct v4l2_subdev *sd,
05f63404 Rui Miguel Silva 2019-02-06  1031  			    struct v4l2_subdev_pad_config *cfg,
05f63404 Rui Miguel Silva 2019-02-06  1032  			    struct v4l2_subdev_format *sdformat)
05f63404 Rui Miguel Silva 2019-02-06  1033  {
05f63404 Rui Miguel Silva 2019-02-06  1034  	struct imx7_csi *csi = v4l2_get_subdevdata(sd);
05f63404 Rui Miguel Silva 2019-02-06  1035  	struct imx_media_video_dev *vdev = csi->vdev;
05f63404 Rui Miguel Silva 2019-02-06  1036  	const struct imx_media_pixfmt *outcc;
05f63404 Rui Miguel Silva 2019-02-06  1037  	struct v4l2_mbus_framefmt *outfmt;
05f63404 Rui Miguel Silva 2019-02-06  1038  	struct v4l2_pix_format vdev_fmt;
05f63404 Rui Miguel Silva 2019-02-06  1039  	const struct imx_media_pixfmt *cc;
05f63404 Rui Miguel Silva 2019-02-06  1040  	struct v4l2_mbus_framefmt *fmt;
05f63404 Rui Miguel Silva 2019-02-06  1041  	struct v4l2_subdev_format format;
05f63404 Rui Miguel Silva 2019-02-06  1042  	int ret = 0;
05f63404 Rui Miguel Silva 2019-02-06  1043  
05f63404 Rui Miguel Silva 2019-02-06  1044  	if (sdformat->pad >= IMX7_CSI_PADS_NUM)
05f63404 Rui Miguel Silva 2019-02-06  1045  		return -EINVAL;
05f63404 Rui Miguel Silva 2019-02-06  1046  
05f63404 Rui Miguel Silva 2019-02-06  1047  	mutex_lock(&csi->lock);
05f63404 Rui Miguel Silva 2019-02-06  1048  
05f63404 Rui Miguel Silva 2019-02-06  1049  	if (csi->is_streaming) {
05f63404 Rui Miguel Silva 2019-02-06  1050  		ret = -EBUSY;
05f63404 Rui Miguel Silva 2019-02-06  1051  		goto out_unlock;
05f63404 Rui Miguel Silva 2019-02-06  1052  	}
05f63404 Rui Miguel Silva 2019-02-06  1053  
05f63404 Rui Miguel Silva 2019-02-06  1054  	imx7_csi_try_fmt(csi, cfg, sdformat, &cc);
05f63404 Rui Miguel Silva 2019-02-06  1055  
05f63404 Rui Miguel Silva 2019-02-06  1056  	fmt = imx7_csi_get_format(csi, cfg, sdformat->pad, sdformat->which);
05f63404 Rui Miguel Silva 2019-02-06  1057  	if (!fmt) {
05f63404 Rui Miguel Silva 2019-02-06  1058  		ret = -EINVAL;
05f63404 Rui Miguel Silva 2019-02-06  1059  		goto out_unlock;
05f63404 Rui Miguel Silva 2019-02-06  1060  	}
05f63404 Rui Miguel Silva 2019-02-06  1061  
05f63404 Rui Miguel Silva 2019-02-06  1062  	*fmt = sdformat->format;
05f63404 Rui Miguel Silva 2019-02-06  1063  
05f63404 Rui Miguel Silva 2019-02-06  1064  	if (sdformat->pad == IMX7_CSI_PAD_SINK) {
05f63404 Rui Miguel Silva 2019-02-06  1065  		/* propagate format to source pads */
05f63404 Rui Miguel Silva 2019-02-06  1066  		format.pad = IMX7_CSI_PAD_SRC;
05f63404 Rui Miguel Silva 2019-02-06  1067  		format.which = sdformat->which;
05f63404 Rui Miguel Silva 2019-02-06  1068  		format.format = sdformat->format;
05f63404 Rui Miguel Silva 2019-02-06  1069  		imx7_csi_try_fmt(csi, cfg, &format, &outcc);
05f63404 Rui Miguel Silva 2019-02-06  1070  
05f63404 Rui Miguel Silva 2019-02-06  1071  		outfmt = imx7_csi_get_format(csi, cfg, IMX7_CSI_PAD_SRC,
05f63404 Rui Miguel Silva 2019-02-06  1072  					     sdformat->which);
05f63404 Rui Miguel Silva 2019-02-06  1073  		*outfmt = format.format;
05f63404 Rui Miguel Silva 2019-02-06  1074  
05f63404 Rui Miguel Silva 2019-02-06  1075  		if (sdformat->which == V4L2_SUBDEV_FORMAT_ACTIVE)
05f63404 Rui Miguel Silva 2019-02-06  1076  			csi->cc[IMX7_CSI_PAD_SRC] = outcc;
05f63404 Rui Miguel Silva 2019-02-06  1077  	}
05f63404 Rui Miguel Silva 2019-02-06  1078  
05f63404 Rui Miguel Silva 2019-02-06  1079  	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY)
05f63404 Rui Miguel Silva 2019-02-06  1080  		goto out_unlock;
05f63404 Rui Miguel Silva 2019-02-06  1081  
05f63404 Rui Miguel Silva 2019-02-06 @1082  	csi->cc[sdformat->pad] = cc;
05f63404 Rui Miguel Silva 2019-02-06  1083  
05f63404 Rui Miguel Silva 2019-02-06  1084  	/* propagate output pad format to capture device */
05f63404 Rui Miguel Silva 2019-02-06  1085  	imx_media_mbus_fmt_to_pix_fmt(&vdev_fmt,
05f63404 Rui Miguel Silva 2019-02-06  1086  				      &csi->format_mbus[IMX7_CSI_PAD_SRC],
05f63404 Rui Miguel Silva 2019-02-06  1087  				      csi->cc[IMX7_CSI_PAD_SRC]);
05f63404 Rui Miguel Silva 2019-02-06  1088  	mutex_unlock(&csi->lock);
05f63404 Rui Miguel Silva 2019-02-06  1089  	imx_media_capture_device_set_format(vdev, &vdev_fmt);
05f63404 Rui Miguel Silva 2019-02-06  1090  
05f63404 Rui Miguel Silva 2019-02-06  1091  	return 0;
05f63404 Rui Miguel Silva 2019-02-06  1092  
05f63404 Rui Miguel Silva 2019-02-06  1093  out_unlock:
05f63404 Rui Miguel Silva 2019-02-06  1094  	mutex_unlock(&csi->lock);
05f63404 Rui Miguel Silva 2019-02-06  1095  
05f63404 Rui Miguel Silva 2019-02-06  1096  	return ret;
05f63404 Rui Miguel Silva 2019-02-06  1097  }
05f63404 Rui Miguel Silva 2019-02-06  1098  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
