Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:37122 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbbHHGzG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Aug 2015 02:55:06 -0400
Message-ID: <55C5A7C6.9080006@gmail.com>
Date: Sat, 08 Aug 2015 01:55:02 -0500
From: Junsu Shin <jjunes0@gmail.com>
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	mchehab@osg.samsung.com, gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, boris.brezillon@free-electrons.com,
	linux-kernel@vger.kernel.org, prabhakar.csengg@gmail.com,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] Staging: media: davinci_vpfe: fix over 80 characters
 coding style issue.
References: <1438916154-5840-1-git-send-email-jjunes0@gmail.com> <20150807044505.GB3537@sudip-pc>
In-Reply-To: <20150807044505.GB3537@sudip-pc>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 08/06/2015 11:45 PM, Sudip Mukherjee wrote:
> On Thu, Aug 06, 2015 at 09:55:54PM -0500, Junsu Shin wrote:
>>  This is a patch to the dm365_ipipe.c that fixes over 80 characters warning detected by checkpatch.pl.
>>  Signed-off-by: Junsu Shin <jjunes0@gmail.com>
> please do not use whitespace before Signed-off-by: line.
>>
>> ---
>>  drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
>> index 1bbb90c..57cd274 100644
>> --- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
>> +++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
>> @@ -1536,8 +1536,9 @@ ipipe_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
>>   * @fse: pointer to v4l2_subdev_frame_size_enum structure.
>>   */
>>  static int
>> -ipipe_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
>> -			  struct v4l2_subdev_frame_size_enum *fse)
>> +ipipe_enum_frame_size(struct v4l2_subdev *sd,
>> +			struct v4l2_subdev_pad_config *cfg,
>> +			struct v4l2_subdev_frame_size_enum *fse)
> since you are modifying this line, please fix up the indention also.
> 
> regards
> sudip
> 

Thanks for pointing it out.
Again, this is a patch to the dm365_ipipe.c that fixes over 80 characters warning detected by the script.
This time I fixed up the indentation issue claimed in the previous one.
Signed-off-by: Junsu Shin <jjunes0@gmail.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 1bbb90c..a474adf 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1536,8 +1536,9 @@ ipipe_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
  * @fse: pointer to v4l2_subdev_frame_size_enum structure.
  */
 static int
-ipipe_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
-			  struct v4l2_subdev_frame_size_enum *fse)
+ipipe_enum_frame_size(struct v4l2_subdev *sd,
+		       struct v4l2_subdev_pad_config *cfg,
+		       struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct vpfe_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt format;
-- 
1.9.1
