Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:34489 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070AbcAJSBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2016 13:01:47 -0500
Received: by mail-ob0-f175.google.com with SMTP id wp13so255669761obc.1
        for <linux-media@vger.kernel.org>; Sun, 10 Jan 2016 10:01:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1667088.5VvxRK5I9C@avalon>
References: <16cd172bc9cec7ce438df95c142d2219998e32fe.1449867690.git.mchehab@osg.samsung.com>
 <1667088.5VvxRK5I9C@avalon>
From: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Date: Sun, 10 Jan 2016 19:01:27 +0100
Message-ID: <CAH-u=83N53gzxGgXZbRAF0aJb_j8Bv0gRLCp6dQwxDuBO90yPA@mail.gmail.com>
Subject: Re: [PATCH] [media] media.h: let be clear that tuners need to use connectors
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2016-01-10 16:30 GMT+01:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Mauro,
>
> Thank you for the patch.
>
> On Friday 11 December 2015 19:01:31 Mauro Carvalho Chehab wrote:
>> The V4L2 core won't be adding connectors to the tuners and other
>> entities that need them. Let it be clear.
>>
>> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>> ---
>>  include/uapi/linux/media.h | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
>> index 86f9753e5c03..cacfceb0d81d 100644
>> --- a/include/uapi/linux/media.h
>> +++ b/include/uapi/linux/media.h
>> @@ -74,10 +74,11 @@ struct media_device_info {
>>  /*
>>   * Connectors
>>   */
>> +/* It is a responsibility of the entity drivers to add connectors and links
>
> Do you mean entity drivers or "master/bridge" (for lack of a better word)
> drivers ?

Is is the responsability of the media device I think...

> I don't think it should be the responsibility of the tuner driver to
> create connectors, as the tuner driver shouldn't know about the entities
> surrounding it.
>
>> */ #define MEDIA_ENT_F_CONN_RF                (MEDIA_ENT_F_BASE + 21)
>>  #define MEDIA_ENT_F_CONN_SVIDEO              (MEDIA_ENT_F_BASE + 22)
>>  #define MEDIA_ENT_F_CONN_COMPOSITE   (MEDIA_ENT_F_BASE + 23)
>> -     /* For internal test signal generators and other debug connectors */
>> +/* For internal test signal generators and other debug connectors */
>>  #define MEDIA_ENT_F_CONN_TEST                (MEDIA_ENT_F_BASE + 24)
>>
>>  /*
>> @@ -105,6 +106,10 @@ struct media_device_info {
>>  #define MEDIA_ENT_F_FLASH            (MEDIA_ENT_F_OLD_SUBDEV_BASE + 2)
>>  #define MEDIA_ENT_F_LENS             (MEDIA_ENT_F_OLD_SUBDEV_BASE + 3)
>>  #define MEDIA_ENT_F_ATV_DECODER              (MEDIA_ENT_F_OLD_SUBDEV_BASE + 4)
>> +/*
>> + * It is a responsibility of the entity drivers to add connectors and links
>> + *   for the tuner entities.
>> + */
>>  #define MEDIA_ENT_F_TUNER            (MEDIA_ENT_F_OLD_SUBDEV_BASE + 5)
>>
>>  #define MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN      MEDIA_ENT_F_OLD_SUBDEV_BASE
>
> --
> Regards,
>
> Laurent Pinchart
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
<div id="DDB4FAA8-2DD7-40BB-A1B8-4E2AA1F9FDF2"><table
style="border-top: 1px solid #aaabb6; margin-top: 30px;">
	<tr>
		<td style="width: 105px; padding-top: 15px;">
			<a href="https://www.avast.com/sig-email?utm_medium=email&utm_source=link&utm_campaign=sig-email&utm_content=webmail"
target="_blank"><img
src="https://ipmcdn.avast.com/images/logo-avast-v1.png" style="width:
90px; height:33px;"/></a>
		</td>
		<td style="width: 470px; padding-top: 20px; color: #41424e;
font-size: 13px; font-family: Arial, Helvetica, sans-serif;
line-height: 18px;">Cet e-mail a été envoyé depuis un ordinateur
protégé par Avast. <br /><a
href="https://www.avast.com/sig-email?utm_medium=email&utm_source=link&utm_campaign=sig-email&utm_content=webmail"
target="_blank" style="color: #4453ea;">www.avast.com</a> 		</td>
	</tr>
</table>
<a href="#DDB4FAA8-2DD7-40BB-A1B8-4E2AA1F9FDF2" width="1" height="1"></a></div>
