Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:48728 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbZFNKuM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 06:50:12 -0400
Received: by bwz9 with SMTP id 9so2817526bwz.37
        for <linux-media@vger.kernel.org>; Sun, 14 Jun 2009 03:50:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200906141246.02884.hverkuil@xs4all.nl>
References: <1244827840-886-1-git-send-email-eduardo.valentin@nokia.com>
	 <1244827840-886-2-git-send-email-eduardo.valentin@nokia.com>
	 <1244827840-886-3-git-send-email-eduardo.valentin@nokia.com>
	 <200906141246.02884.hverkuil@xs4all.nl>
Date: Sun, 14 Jun 2009 13:50:13 +0300
Message-ID: <a0580c510906140350o532a106dm1e2f876ebc60b3d0@mail.gmail.com>
Subject: Re: [PATCHv7 2/9] v4l2: video device: Add V4L2_CTRL_CLASS_FM_TX
	controls
From: Eduardo Valentin <edubezval@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Eduardo Valentin <eduardo.valentin@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sun, Jun 14, 2009 at 1:46 PM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
> On Friday 12 June 2009 19:30:33 Eduardo Valentin wrote:
>> This patch adds a new class of extended controls. This class
>> is intended to support FM Radio Modulators properties such as:
>> rds, audio limiters, audio compression, pilot tone generation,
>> tuning power levels and preemphasis properties.
>>
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
>> ---
>>  linux/include/linux/videodev2.h |   34 ++++++++++++++++++++++++++++++++++
>>  1 files changed, 34 insertions(+), 0 deletions(-)
>>
>> diff --git a/linux/include/linux/videodev2.h b/linux/include/linux/videodev2.h
>> index b8cffc9..9733435 100644
>> --- a/linux/include/linux/videodev2.h
>> +++ b/linux/include/linux/videodev2.h
>> @@ -806,6 +806,7 @@ struct v4l2_ext_controls {
>>  #define V4L2_CTRL_CLASS_USER 0x00980000      /* Old-style 'user' controls */
>>  #define V4L2_CTRL_CLASS_MPEG 0x00990000      /* MPEG-compression controls */
>>  #define V4L2_CTRL_CLASS_CAMERA 0x009a0000    /* Camera class controls */
>> +#define V4L2_CTRL_CLASS_FM_TX 0x009b0000     /* FM Modulator control class */
>>
>>  #define V4L2_CTRL_ID_MASK              (0x0fffffff)
>>  #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
>> @@ -1144,6 +1145,39 @@ enum  v4l2_exposure_auto_type {
>>
>>  #define V4L2_CID_PRIVACY                     (V4L2_CID_CAMERA_CLASS_BASE+16)
>>
>> +/* FM Modulator class control IDs */
>> +#define V4L2_CID_FM_TX_CLASS_BASE            (V4L2_CTRL_CLASS_FM_TX | 0x900)
>> +#define V4L2_CID_FM_TX_CLASS                 (V4L2_CTRL_CLASS_FM_TX | 1)
>> +
>> +#define V4L2_CID_RDS_ENABLED                 (V4L2_CID_FM_TX_CLASS_BASE + 1)
>> +#define V4L2_CID_RDS_PI                              (V4L2_CID_FM_TX_CLASS_BASE + 2)
>> +#define V4L2_CID_RDS_PTY                     (V4L2_CID_FM_TX_CLASS_BASE + 3)
>> +#define V4L2_CID_RDS_PS_NAME                 (V4L2_CID_FM_TX_CLASS_BASE + 4)
>> +#define V4L2_CID_RDS_RADIO_TEXT                      (V4L2_CID_FM_TX_CLASS_BASE + 5)
>
> I think these RDS controls should be renamed to V4L2_CID_RDS_TX_. This makes
> it clear that these controls relate to the RDS transmitter instead of a
> receiver. I would not be surprised to see similar controls appear for an RDS
> receiver in the future.
>
>> +
>> +#define V4L2_CID_AUDIO_LIMITER_ENABLED               (V4L2_CID_FM_TX_CLASS_BASE + 6)
>> +#define V4L2_CID_AUDIO_LIMITER_RELEASE_TIME  (V4L2_CID_FM_TX_CLASS_BASE + 7)
>> +#define V4L2_CID_AUDIO_LIMITER_DEVIATION     (V4L2_CID_FM_TX_CLASS_BASE + 8)
>> +
>> +#define V4L2_CID_AUDIO_COMPRESSION_ENABLED   (V4L2_CID_FM_TX_CLASS_BASE + 9)
>> +#define V4L2_CID_AUDIO_COMPRESSION_GAIN              (V4L2_CID_FM_TX_CLASS_BASE + 10)
>> +#define V4L2_CID_AUDIO_COMPRESSION_THRESHOLD (V4L2_CID_FM_TX_CLASS_BASE + 11)
>> +#define V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME       (V4L2_CID_FM_TX_CLASS_BASE + 12)
>> +#define V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME      (V4L2_CID_FM_TX_CLASS_BASE + 13)
>> +
>> +#define V4L2_CID_PILOT_TONE_ENABLED          (V4L2_CID_FM_TX_CLASS_BASE + 14)
>> +#define V4L2_CID_PILOT_TONE_DEVIATION                (V4L2_CID_FM_TX_CLASS_BASE + 15)
>> +#define V4L2_CID_PILOT_TONE_FREQUENCY                (V4L2_CID_FM_TX_CLASS_BASE + 16)
>> +
>> +#define V4L2_CID_PREEMPHASIS                 (V4L2_CID_FM_TX_CLASS_BASE + 17)
>> +enum v4l2_fm_tx_preemphasis {
>> +     V4L2_FM_TX_PREEMPHASIS_DISABLED         = 0,
>> +     V4L2_FM_TX_PREEMPHASIS_50_uS            = 1,
>> +     V4L2_FM_TX_PREEMPHASIS_75_uS            = 2,
>> +};
>
> I suggest renaming this to V4L2_CID_FM_TX_PREEMPHASIS. There is already a
> similar V4L2_CID_MPEG_EMPHASIS control and others might well appear in the
> future, so I think this name should be more specific to the FM_TX API.

Right. Agreed for both suggestions.

>
>> +#define V4L2_CID_TUNE_POWER_LEVEL            (V4L2_CID_FM_TX_CLASS_BASE + 18)
>> +#define V4L2_CID_TUNE_ANTENNA_CAPACITOR              (V4L2_CID_FM_TX_CLASS_BASE + 19)
>> +
>>  /*
>>   *   T U N I N G
>>   */
>
> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Eduardo Bezerra Valentin
