Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:49463 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030216Ab3FUKc3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 06:32:29 -0400
Received: by mail-la0-f45.google.com with SMTP id fr10so6997715lab.18
        for <linux-media@vger.kernel.org>; Fri, 21 Jun 2013 03:32:28 -0700 (PDT)
Message-ID: <51C42BA5.9050105@cogentembedded.com>
Date: Fri, 21 Jun 2013 14:32:05 +0400
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
MIME-Version: 1.0
To: Katsuya MATSUBARA <matsu@igel.co.jp>
CC: sergei.shtylyov@cogentembedded.com, g.liakhovetski@gmx.de,
	mchehab@redhat.com, linux-media@vger.kernel.org,
	magnus.damm@gmail.com, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com
Subject: Re: [PATCH v6] V4L2: soc_camera: Renesas R-Car VIN driver
References: <51C40974.600@cogentembedded.com>	<20130621.180932.452518378.matsu@igel.co.jp>	<51C41F66.1060300@cogentembedded.com> <20130621.190157.27985389.matsu@igel.co.jp>
In-Reply-To: <20130621.190157.27985389.matsu@igel.co.jp>
Content-Type: multipart/mixed;
 boundary="------------000007070703010801000704"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000007070703010801000704
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Katsuya MATSUBARA wrote:
> Hi Vladimir,
>
> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> Date: Fri, 21 Jun 2013 13:39:50 +0400
>
> (snip)
>   
>>> I have not seen such i2c errors during capturing and booting.
>>> But I have seen that querystd() in the ml86v7667 driver often
>>> returns V4L2_STD_UNKNOWN, although the corresponding function
>>>   
>>>       
>> could you try Hans's fix:
>> https://patchwork.kernel.org/patch/2640701/
>>     
>
> The fix has been already applied in my environment.
>   
I've found that after some iteration of submission we disabled the input 
signal in autodetection in ml86v7667_init(). per recommendations.
That could be the case why the input signal is not locked.

On adv7180 it still has optional autodetection but Hans recommended to 
get rid from runtime autodetection.
So I've added input signal detection only during boot time.

Could you please try the attached patch?

Regards,
Vladimir

--------------000007070703010801000704
Content-Type: text/x-patch;
 name="0054-ml86v7667_query_std_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0054-ml86v7667_query_std_fix.patch"

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

Subject: V4L2: decoder: ml86v7667: fix querystd

Input signal autodetection is disabled, hence the cached V4L2_STD must be used

Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

---
 drivers/media/i2c/ml86v7667.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

Index: build/drivers/media/i2c/ml86v7667.c
===================================================================
--- build.orig/drivers/media/i2c/ml86v7667.c	2013-06-21 13:24:13.000000000 +0300
+++ build/drivers/media/i2c/ml86v7667.c	2013-06-21 13:26:07.308872980 +0300
@@ -162,17 +162,9 @@
 
 static int ml86v7667_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	int status;
+	struct ml86v7667_priv *priv = to_ml86v7667(sd);
 
-	status = i2c_smbus_read_byte_data(client, STATUS_REG);
-	if (status < 0)
-		return status;
-
-	if (status & STATUS_HLOCK_DETECT)
-		*std &= status & STATUS_NTSCPAL ? V4L2_STD_625_50 : V4L2_STD_525_60;
-	else
-		*std = V4L2_STD_UNKNOWN;
+	*std = priv->std;
 
 	return 0;
 }

--------------000007070703010801000704--
