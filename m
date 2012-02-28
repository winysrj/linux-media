Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53170 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421Ab2B1Wwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Feb 2012 17:52:43 -0500
MIME-Version: 1.0
In-Reply-To: <201202281105.00244.hverkuil@xs4all.nl>
References: <1330114471-26435-1-git-send-email-manjunatha_halli@ti.com>
 <201202250916.02506.hverkuil@xs4all.nl> <CAMT6PycHM0Pa+NovFaAaHGJ9nnwKEpXyMacH-5DBvFUacFkzjw@mail.gmail.com>
 <201202281105.00244.hverkuil@xs4all.nl>
From: halli manjunatha <hallimanju@gmail.com>
Date: Tue, 28 Feb 2012 16:52:21 -0600
Message-ID: <CAMT6Pye+3rmi8n=cjZHt25QUNo=_zQYxQ-TVmufwc4+vPUL3-w@mail.gmail.com>
Subject: Re: [PATCH 3/3] wl128x: Add sysfs based support for FM features
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Manjunatha Halli <x0130808@ti.com>, shahed@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 28, 2012 at 4:05 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Monday, February 27, 2012 17:29:18 halli manjunatha wrote:
>> Hi Hans,
>>
>> Agreed I don't mind to create new controls for below things
>>
>> 1) FM RX Band selection (US/Europe, Japan and Russian bands)
>> 2) FM RX RDS AF turn ON/OFF
>> 3) FM RX RSSI level set/get
>> 4) FM TX Alternate Frequency set/get
>> 5) FM RX De-Emphasis mode set/get
>>
>> However, previously you have suggested me to hide few controls (like
>> band selection) from the user but few of our application wanted
>> controls like above and that is why I have created the sysfs entries.
>>
>> Please suggest me how can I move forward with new controls or with sysfs?
>
> The first question is which of these controls are general to FM receivers or
> transmitters, and which are specific to this chipset. The chipset specific
> controls should be private controls (look at V4L2_CID_MPEG_CX2341X_BASE in
> videodev2.h how those are defined). The others should be defined as new
> controls of the FM_TX class or the FM_RX class. The FM_RX class should be
> defined as a new class as it doesn't exist at the moment. Don't forget to
> document these controls clearly.
>
> With regards to the band selection: I remember that there was a discussion,
> but not the details. Do you have a link to that discussion? I can't find it
> (at least not quickly :-) ).

Below features are generic to all FM receivers so we can add new CID's
for below features
1) FM RX RDS AF turn ON/OFF
2) FM TX Alternate Frequency set/get

About other 3 features its different issue,
    1) FM RX Band selection (US/Europe, Japan and Russian bands)
    2) FM RX RSSI level set/get
    3) FM RX De-Emphasis mode set/get

All these 3 features are generic to any FM receiver, only question is
does all FM receivers wants to expose these controls to application
writer?

Example Band selection, every FM receiver at the minimum supports both
Europe and Japan band, now the question is should we add a CID to
switch between these two bands?

Below is the link to our discussion on the same topic a few time back.

      https://lkml.org/lkml/2010/11/18/43

>
> There is one other thing that would be nice if that could be changed in the
> driver: currently there is only one radio device that can be used for both
> the receiver and the transmitter. During a V4L meeting last year we had a
> discussion about that and the conclusion was that receivers and transmitters
> should have their own radio device.
>
> The reason for that decision was that the VIDIOC_G/S_FREQUENCY ioctls cannot
> tell the difference between a transmitter and a receiver. If you have separate
> receiver and transmitter radio nodes this confusion goes away. In addition,
> this same restriction already applies to video and vbi nodes (i.e. a video or
> vbi node can be used for capture or output, but not both, unless it is a
> mem2mem device).
>
> I don't know how much work it is to implement this, but I would appreciate it
> if you could think about this a bit.

I will look in to this and submit a new patch to create 2 separate
device nodes for FM RX and FM TX once after this patch set.

Regards
Manju
>
> Regards,
>
> � � � �Hans
>
>>
>> Regards
>> Manju
>>
>>
>> On Sat, Feb 25, 2012 at 2:16 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> >
>> > Hi Manjunatha!
>> >
>> > On Friday, February 24, 2012 21:14:31 manjunatha_halli@ti.com wrote:
>> > > From: Manjunatha Halli <x0130808@ti.com>
>> > >
>> > > This patch adds support for below features via sysfs file system
>> > >
>> > > 1) FM RX Band selection (US/Europe, Japan and Russian bands)
>> > > 2) FM RX RDS AF turn ON/OFF
>> > > 3) FM RX RSSI level set/get
>> > > 4) FM TX Alternate Frequency set/get
>> > > 5) FM RX De-Emphasis mode set/get
>> >
>> > Why sysfs? Wouldn't it make more sense to create controls for this?
>> > That's the V4L way...
>> >
>> > Regards,
>> >
>> > � � � �Hans
>> >
>> > >
>> > > Also this patch fixes below issues
>> > >
>> > > 1) FM audio volume gain � � � setting
>> > > 2) Default rssi � � � level is set to 8 instead of 20
>> > > 3) Issue related to audio mute/unmute
>> > > 4)Enable FM RX AF support in driver
>> > > 5)In wrap_around seek mode try for once
>> > >
>> > > Signed-off-by: Manjunatha Halli <x0130808@ti.com>
>> > > ---
>> > > �drivers/media/radio/wl128x/fmdrv.h � � � �| � �1 +
>> > > �drivers/media/radio/wl128x/fmdrv_common.c | � 11 ++-
>> > > �drivers/media/radio/wl128x/fmdrv_common.h | � 26 +++--
>> > > �drivers/media/radio/wl128x/fmdrv_rx.c � � | � 13 ++-
>> > > �drivers/media/radio/wl128x/fmdrv_tx.c � � | � �6 +-
>> > > �drivers/media/radio/wl128x/fmdrv_v4l2.c � | �188 ++++++++++++++++++++++++++++-
>> > > �6 files changed, 225 insertions(+), 20 deletions(-)
>> > >
>> > > diff --git a/drivers/media/radio/wl128x/fmdrv.h b/drivers/media/radio/wl128x/fmdrv.h
>> > > index d84ad9d..8fe773d 100644
>> > > --- a/drivers/media/radio/wl128x/fmdrv.h
>> > > +++ b/drivers/media/radio/wl128x/fmdrv.h
>> > > @@ -196,6 +196,7 @@ struct fmtx_data {
>> > > � � � u16 aud_mode;
>> > > � � � u32 preemph;
>> > > � � � u32 tx_frq;
>> > > + � � u32 af_frq;
>> > > � � � struct tx_rds rds;
>> > > �};
>> > >
>> > > diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
>> > > index fcce61a..1a580a7 100644
>> > > --- a/drivers/media/radio/wl128x/fmdrv_common.c
>> > > +++ b/drivers/media/radio/wl128x/fmdrv_common.c
>> > > @@ -58,6 +58,13 @@ static struct region_info region_configs[] = {
>> > > � � � �.top_freq = 90000, � � /* 90 MHz */
>> > > � � � �.fm_band = 1,
>> > > � � � �},
>> > > + � � /* Russian (OIRT) band */
>> > > + � � {
>> > > + � � �.chanl_space = FM_CHANNEL_SPACING_200KHZ * FM_FREQ_MUL,
>> > > + � � �.bot_freq = 65800, � � /* 65.8 MHz */
>> > > + � � �.top_freq = 74000, � � /* 74 MHz */
>> > > + � � �.fm_band = 2,
>> > > + � � �},
>> > > �};
>> > >
>> > > �/* Band selection */
>> > > @@ -659,7 +666,7 @@ static void fm_rx_update_af_cache(struct fmdev *fmdev, u8 af)
>> > > � � � if (reg_idx == FM_BAND_JAPAN && af > FM_RDS_MAX_AF_JAPAN)
>> > > � � � � � � � return;
>> > >
>> > > - � � freq = fmdev->rx.region.bot_freq + (af * 100);
>> > > + � � freq = fmdev->rx.region.bot_freq + (af * FM_KHZ);
>> > > � � � if (freq == fmdev->rx.freq) {
>> > > � � � � � � � fmdbg("Current freq(%d) is matching with received AF(%d)\n",
>> > > � � � � � � � � � � � � � � � fmdev->rx.freq, freq);
>> > > @@ -1576,7 +1583,7 @@ int fmc_prepare(struct fmdev *fmdev)
>> > > � � � fmdev->rx.rds.flag = FM_RDS_DISABLE;
>> > > � � � fmdev->rx.freq = FM_UNDEFINED_FREQ;
>> > > � � � fmdev->rx.rds_mode = FM_RDS_SYSTEM_RDS;
>> > > - � � fmdev->rx.af_mode = FM_RX_RDS_AF_SWITCH_MODE_OFF;
>> > > + � � fmdev->rx.af_mode = FM_RX_RDS_AF_SWITCH_MODE_ON;
>> > > � � � fmdev->irq_info.retry = 0;
>> > >
>> > > � � � fmdev->tx_data.tx_frq = FM_UNDEFINED_FREQ;
>> > > diff --git a/drivers/media/radio/wl128x/fmdrv_common.h b/drivers/media/radio/wl128x/fmdrv_common.h
>> > > index 196ff7d..aaa54bc 100644
>> > > --- a/drivers/media/radio/wl128x/fmdrv_common.h
>> > > +++ b/drivers/media/radio/wl128x/fmdrv_common.h
>> > > @@ -203,6 +203,7 @@ struct fm_event_msg_hdr {
>> > > �/* Band types */
>> > > �#define FM_BAND_EUROPE_US � �0
>> > > �#define FM_BAND_JAPAN � � � � � � � �1
>> > > +#define FM_BAND_RUSSIAN � � � � � � �2
>> > >
>> > > �/* Seek directions */
>> > > �#define FM_SEARCH_DIRECTION_DOWN � � 0
>> > > @@ -216,14 +217,11 @@ struct fm_event_msg_hdr {
>> > >
>> > > �/* Min and Max volume */
>> > > �#define FM_RX_VOLUME_MIN � � 0
>> > > -#define FM_RX_VOLUME_MAX � � 70
>> > > -
>> > > -/* Volume gain step */
>> > > -#define FM_RX_VOLUME_GAIN_STEP � � � 0x370
>> > > +#define FM_RX_VOLUME_MAX � � 0xffff
>> > >
>> > > �/* Mute modes */
>> > > -#define � � �FM_MUTE_ON � � � � � � �0
>> > > -#define FM_MUTE_OFF � � � � �1
>> > > +#define FM_MUTE_OFF � � � � �0
>> > > +#define � � �FM_MUTE_ON � � � � � � �1
>> > > �#define � � �FM_MUTE_ATTENUATE � � � 2
>> > >
>> > > �#define FM_RX_UNMUTE_MODE � � � � � �0x00
>> > > @@ -238,8 +236,8 @@ struct fm_event_msg_hdr {
>> > > �#define FM_RX_RF_DEPENDENT_MUTE_OFF �0
>> > >
>> > > �/* RSSI threshold min and max */
>> > > -#define FM_RX_RSSI_THRESHOLD_MIN � � -128
>> > > -#define FM_RX_RSSI_THRESHOLD_MAX � � 127
>> > > +#define FM_RX_RSSI_THRESHOLD_MIN � � 0 � � � /* 0 dBuV */
>> > > +#define FM_RX_RSSI_THRESHOLD_MAX � � 127 � � /* 191.1477 dBuV */
>> > >
>> > > �/* Stereo/Mono mode */
>> > > �#define FM_STEREO_MODE � � � � � � � 0
>> > > @@ -352,8 +350,8 @@ struct fm_event_msg_hdr {
>> > > � * Default RX mode configuration. Chip will be configured
>> > > � * with this default values after loading RX firmware.
>> > > � */
>> > > -#define FM_DEFAULT_RX_VOLUME � � � � 10
>> > > -#define FM_DEFAULT_RSSI_THRESHOLD � �20
>> > > +#define FM_DEFAULT_RX_VOLUME � � � � 10000
>> > > +#define FM_DEFAULT_RSSI_THRESHOLD � �8 � � � /* 12.0408 dBuV */
>> > >
>> > > �/* Range for TX power level in units for dB/uV */
>> > > �#define FM_PWR_LVL_LOW � � � � � � � � � � � 91
>> > > @@ -403,5 +401,13 @@ int fmc_get_mode(struct fmdev *, u8 *);
>> > > �#define FM_CHANNEL_SPACING_200KHZ 4
>> > > �#define FM_FREQ_MUL 50
>> > >
>> > > +#define FM_US_BAND_LOW � � � � � � � 87500
>> > > +#define FM_US_BAND_HIGH � � � � � � �180000
>> > > +#define FM_JAPAN_BAND_LOW � �76000
>> > > +#define FM_JAPAN_BAND_HIGH � 90000
>> > > +
>> > > +#define FM_KHZ � � � � � � � � � � � 100
>> > > +
>> > > +
>> > > �#endif
>> > >
>> > > diff --git a/drivers/media/radio/wl128x/fmdrv_rx.c b/drivers/media/radio/wl128x/fmdrv_rx.c
>> > > index a806bda..0965270 100644
>> > > --- a/drivers/media/radio/wl128x/fmdrv_rx.c
>> > > +++ b/drivers/media/radio/wl128x/fmdrv_rx.c
>> > > @@ -276,6 +276,10 @@ again:
>> > > � � � � � � � � � � � /* Calculate frequency index to write */
>> > > � � � � � � � � � � � next_frq = (fmdev->rx.freq -
>> > > � � � � � � � � � � � � � � � � � � � fmdev->rx.region.bot_freq) / FM_FREQ_MUL;
>> > > +
>> > > + � � � � � � � � � � /* If no valid chanel then report default frequency */
>> > > + � � � � � � � � � � wrap_around = 0;
>> > > +
>> > > � � � � � � � � � � � goto again;
>> > > � � � � � � � }
>> > > � � � } else {
>> > > @@ -290,6 +294,7 @@ again:
>> > > � � � � � � � � � � � � � � � ((u32)curr_frq * FM_FREQ_MUL));
>> > >
>> > > � � � }
>> > > +
>> > > � � � /* Reset RDS cache and current station pointers */
>> > > � � � fm_rx_reset_rds_cache(fmdev);
>> > > � � � fm_rx_reset_station_info(fmdev);
>> > > @@ -310,7 +315,6 @@ int fm_rx_set_volume(struct fmdev *fmdev, u16 vol_to_set)
>> > > � � � � � � � � � � � � �FM_RX_VOLUME_MIN, FM_RX_VOLUME_MAX);
>> > > � � � � � � � return -EINVAL;
>> > > � � � }
>> > > - � � vol_to_set *= FM_RX_VOLUME_GAIN_STEP;
>> > >
>> > > � � � payload = vol_to_set;
>> > > � � � ret = fmc_send_cmd(fmdev, VOLUME_SET, REG_WR, &payload,
>> > > @@ -333,7 +337,7 @@ int fm_rx_get_volume(struct fmdev *fmdev, u16 *curr_vol)
>> > > � � � � � � � return -ENOMEM;
>> > > � � � }
>> > >
>> > > - � � *curr_vol = fmdev->rx.volume / FM_RX_VOLUME_GAIN_STEP;
>> > > + � � *curr_vol = fmdev->rx.volume;
>> > >
>> > > � � � return 0;
>> > > �}
>> > > @@ -364,7 +368,8 @@ int fm_rx_set_region(struct fmdev *fmdev, u8 region_to_set)
>> > > � � � int ret;
>> > >
>> > > � � � if (region_to_set != FM_BAND_EUROPE_US &&
>> > > - � � � � region_to_set != FM_BAND_JAPAN) {
>> > > + � � � � region_to_set != FM_BAND_JAPAN &&
>> > > + � � � � region_to_set != FM_BAND_RUSSIAN) {
>> > > � � � � � � � fmerr("Invalid band\n");
>> > > � � � � � � � return -EINVAL;
>> > > � � � }
>> > > @@ -550,7 +555,7 @@ int fm_rx_set_rssi_threshold(struct fmdev *fmdev, short rssi_lvl_toset)
>> > > � � � � � � � fmerr("Invalid RSSI threshold level\n");
>> > > � � � � � � � return -EINVAL;
>> > > � � � }
>> > > - � � payload = (u16)rssi_lvl_toset;
>> > > + � � payload = (u16) rssi_lvl_toset;
>> > > � � � ret = fmc_send_cmd(fmdev, SEARCH_LVL_SET, REG_WR, &payload,
>> > > � � � � � � � � � � � sizeof(payload), NULL, NULL);
>> > > � � � if (ret < 0)
>> > > diff --git a/drivers/media/radio/wl128x/fmdrv_tx.c b/drivers/media/radio/wl128x/fmdrv_tx.c
>> > > index 6d879fb..52e5120 100644
>> > > --- a/drivers/media/radio/wl128x/fmdrv_tx.c
>> > > +++ b/drivers/media/radio/wl128x/fmdrv_tx.c
>> > > @@ -177,10 +177,10 @@ int fm_tx_set_af(struct fmdev *fmdev, u32 af)
>> > >
>> > > � � � fmdbg("AF: %d\n", af);
>> > >
>> > > - � � af = (af - 87500) / 100;
>> > > + � � fmdev->tx_data.af_frq = af;
>> > > + � � af = (af - FM_US_BAND_LOW) / FM_KHZ;
>> > > � � � payload = (u16)af;
>> > > - � � ret = fmc_send_cmd(fmdev, TA_SET, REG_WR, &payload,
>> > > - � � � � � � � � � � sizeof(payload), NULL, NULL);
>> > > + � � ret = fmc_send_cmd(fmdev, AF, REG_WR, &payload, sizeof(payload), NULL, NULL);
>> > > � � � if (ret < 0)
>> > > � � � � � � � return ret;
>> > >
>> > > diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
>> > > index b9da1ae..4bd7bf1 100644
>> > > --- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
>> > > +++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
>> > > @@ -110,6 +110,184 @@ static u32 fm_v4l2_fops_poll(struct file *file, struct poll_table_struct *pts)
>> > > � � � return 0;
>> > > �}
>> > >
>> > > +/**********************************************************************/
>> > > +/* functions called from sysfs subsystem */
>> > > +
>> > > +static ssize_t show_fmtx_af(struct device *dev,
>> > > + � � � � � � struct device_attribute *attr, char *buf)
>> > > +{
>> > > + � � struct fmdev *fmdev = dev_get_drvdata(dev);
>> > > +
>> > > + � � return sprintf(buf, "%d\n", fmdev->tx_data.af_frq);
>> > > +}
>> > > +
>> > > +static ssize_t store_fmtx_af(struct device *dev,
>> > > + � � � � � � struct device_attribute *attr, char *buf, size_t size)
>> > > +{
>> > > + � � int ret;
>> > > + � � unsigned long af_freq;
>> > > + � � struct fmdev *fmdev = dev_get_drvdata(dev);
>> > > +
>> > > + � � if (kstrtoul(buf, 0, &af_freq))
>> > > + � � � � � � return -EINVAL;
>> > > +
>> > > + � � ret = fm_tx_set_af(fmdev, af_freq);
>> > > + � � if (ret < 0) {
>> > > + � � � � � � fmerr("Failed to set FM TX AF Frequency\n");
>> > > + � � � � � � return ret;
>> > > + � � }
>> > > + � � return size;
>> > > +}
>> > > +
>> > > +static ssize_t show_fmrx_deemphasis(struct device *dev,
>> > > + � � � � � � struct device_attribute *attr, char *buf)
>> > > +{
>> > > + � � struct fmdev *fmdev = dev_get_drvdata(dev);
>> > > +
>> > > + � � return sprintf(buf, "%d\n", (fmdev->rx.deemphasis_mode ==
>> > > + � � � � � � � � � � � � � � FM_RX_EMPHASIS_FILTER_50_USEC) ? 50 : 75);
>> > > +}
>> > > +
>> > > +static ssize_t store_fmrx_deemphasis(struct device *dev,
>> > > + � � � � � � struct device_attribute *attr, char *buf, size_t size)
>> > > +{
>> > > + � � int ret;
>> > > + � � unsigned long deemph_mode;
>> > > + � � struct fmdev *fmdev = dev_get_drvdata(dev);
>> > > +
>> > > + � � if (kstrtoul(buf, 0, &deemph_mode))
>> > > + � � � � � � return -EINVAL;
>> > > +
>> > > + � � if (deemph_mode != 50 && deemph_mode != 75)
>> > > + � � � � � � return -EINVAL;
>> > > +
>> > > + � � if (deemph_mode == 50)
>> > > + � � � � � � deemph_mode = FM_RX_EMPHASIS_FILTER_50_USEC;
>> > > + � � else
>> > > + � � � � � � deemph_mode = FM_RX_EMPHASIS_FILTER_75_USEC;
>> > > +
>> > > + � � ret = fm_rx_set_deemphasis_mode(fmdev, deemph_mode);
>> > > + � � if (ret < 0) {
>> > > + � � � � � � fmerr("Failed to set De-emphasis Mode\n");
>> > > + � � � � � � return ret;
>> > > + � � }
>> > > +
>> > > + � � return size;
>> > > +}
>> > > +
>> > > +static ssize_t show_fmrx_af(struct device *dev,
>> > > + � � � � � � struct device_attribute *attr, char *buf)
>> > > +{
>> > > + � � struct fmdev *fmdev = dev_get_drvdata(dev);
>> > > +
>> > > + � � return sprintf(buf, "%d\n", fmdev->rx.af_mode);
>> > > +}
>> > > +
>> > > +static ssize_t store_fmrx_af(struct device *dev,
>> > > + � � � � � � struct device_attribute *attr, char *buf, size_t size)
>> > > +{
>> > > + � � int ret;
>> > > + � � unsigned long af_mode;
>> > > + � � struct fmdev *fmdev = dev_get_drvdata(dev);
>> > > +
>> > > + � � if (kstrtoul(buf, 0, &af_mode))
>> > > + � � � � � � return -EINVAL;
>> > > +
>> > > + � � if (af_mode < 0 || af_mode > 1)
>> > > + � � � � � � return -EINVAL;
>> > > +
>> > > + � � ret = fm_rx_set_af_switch(fmdev, af_mode);
>> > > + � � if (ret < 0) {
>> > > + � � � � � � fmerr("Failed to set AF Switch\n");
>> > > + � � � � � � return ret;
>> > > + � � }
>> > > +
>> > > + � � return size;
>> > > +}
>> > > +
>> > > +static ssize_t show_fmrx_band(struct device *dev,
>> > > + � � � � � � struct device_attribute *attr, char *buf)
>> > > +{
>> > > + � � struct fmdev *fmdev = dev_get_drvdata(dev);
>> > > +
>> > > + � � return sprintf(buf, "%d\n", fmdev->rx.region.fm_band);
>> > > +}
>> > > +
>> > > +static ssize_t store_fmrx_band(struct device *dev,
>> > > + � � � � � � struct device_attribute *attr, char *buf, size_t size)
>> > > +{
>> > > + � � int ret;
>> > > + � � unsigned long fm_band;
>> > > + � � struct fmdev *fmdev = dev_get_drvdata(dev);
>> > > +
>> > > + � � if (kstrtoul(buf, 0, &fm_band))
>> > > + � � � � � � return -EINVAL;
>> > > +
>> > > + � � if (fm_band < FM_BAND_EUROPE_US || fm_band > FM_BAND_RUSSIAN)
>> > > + � � � � � � return -EINVAL;
>> > > +
>> > > + � � ret = fm_rx_set_region(fmdev, fm_band);
>> > > + � � if (ret < 0) {
>> > > + � � � � � � fmerr("Failed to set FM Band\n");
>> > > + � � � � � � return ret;
>> > > + � � }
>> > > +
>> > > + � � return size;
>> > > +}
>> > > +
>> > > +static ssize_t show_fmrx_rssi_lvl(struct device *dev,
>> > > + � � � � � � struct device_attribute *attr, char *buf)
>> > > +{
>> > > + � � struct fmdev *fmdev = dev_get_drvdata(dev);
>> > > +
>> > > + � � return sprintf(buf, "%d\n", fmdev->rx.rssi_threshold);
>> > > +}
>> > > +static ssize_t store_fmrx_rssi_lvl(struct device *dev,
>> > > + � � � � � � struct device_attribute *attr, char *buf, size_t size)
>> > > +{
>> > > + � � int ret;
>> > > + � � unsigned long rssi_lvl;
>> > > + � � struct fmdev *fmdev = dev_get_drvdata(dev);
>> > > +
>> > > + � � if (kstrtoul(buf, 0, &rssi_lvl))
>> > > + � � � � � � return -EINVAL;
>> > > +
>> > > + � � ret = fm_rx_set_rssi_threshold(fmdev, rssi_lvl);
>> > > + � � if (ret < 0) {
>> > > + � � � � � � fmerr("Failed to set RSSI level\n");
>> > > + � � � � � � return ret;
>> > > + � � }
>> > > +
>> > > + � � return size;
>> > > +}
>> > > +
>> > > +/* structures specific for sysfs entries */
>> > > +static struct kobj_attribute v4l2_fmtx_rds_af =
>> > > +__ATTR(fmtx_rds_af, 0666, (void *)show_fmtx_af, (void *)store_fmtx_af);
>> > > +
>> > > +static struct kobj_attribute v4l2_fm_deemph_mode =
>> > > +__ATTR(fmrx_deemph_mode, 0666, (void *)show_fmrx_deemphasis, (void *)store_fmrx_deemphasis);
>> > > +
>> > > +static struct kobj_attribute v4l2_fm_rds_af =
>> > > +__ATTR(fmrx_rds_af, 0666, (void *)show_fmrx_af, (void *)store_fmrx_af);
>> > > +
>> > > +static struct kobj_attribute v4l2_fm_band =
>> > > +__ATTR(fmrx_band, 0666, (void *)show_fmrx_band, (void *)store_fmrx_band);
>> > > +
>> > > +static struct kobj_attribute v4l2_fm_rssi_lvl =
>> > > +__ATTR(fmrx_rssi_lvl, 0666, (void *) show_fmrx_rssi_lvl, (void *)store_fmrx_rssi_lvl);
>> > > +
>> > > +static struct attribute *v4l2_fm_attrs[] = {
>> > > + � � &v4l2_fmtx_rds_af.attr,
>> > > + � � &v4l2_fm_deemph_mode.attr,
>> > > + � � &v4l2_fm_rds_af.attr,
>> > > + � � &v4l2_fm_band.attr,
>> > > + � � &v4l2_fm_rssi_lvl.attr,
>> > > + � � NULL,
>> > > +};
>> > > +static struct attribute_group v4l2_fm_attr_grp = {
>> > > + � � .attrs = v4l2_fm_attrs,
>> > > +};
>> > > �/*
>> > > � * Handle open request for "/dev/radioX" device.
>> > > � * Start with FM RX mode as default.
>> > > @@ -142,6 +320,12 @@ static int fm_v4l2_fops_open(struct file *file)
>> > > � � � }
>> > > � � � radio_disconnected = 1;
>> > >
>> > > + � � /* Register sysfs entries */
>> > > + � � ret = sysfs_create_group(&fmdev->radio_dev->dev.kobj, &v4l2_fm_attr_grp);
>> > > + � � if (ret) {
>> > > + � � � � � � pr_err("failed to create sysfs entries");
>> > > + � � � � � � return ret;
>> > > + � � }
>> > > � � � return ret;
>> > > �}
>> > >
>> > > @@ -162,6 +346,8 @@ static int fm_v4l2_fops_release(struct file *file)
>> > > � � � � � � � return ret;
>> > > � � � }
>> > >
>> > > + � � sysfs_remove_group(&fmdev->radio_dev->dev.kobj, &v4l2_fm_attr_grp);
>> > > +
>> > > � � � ret = fmc_release(fmdev);
>> > > � � � if (ret < 0) {
>> > > � � � � � � � fmerr("FM CORE release failed\n");
>> > > @@ -582,7 +768,7 @@ int fm_v4l2_init_video_device(struct fmdev *fmdev, int radio_nr)
>> > > � � � � � � � � � � � FM_RX_VOLUME_MAX, 1, FM_RX_VOLUME_MAX);
>> > >
>> > > � � � v4l2_ctrl_new_std(&fmdev->ctrl_handler, &fm_ctrl_ops,
>> > > - � � � � � � � � � � V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
>> > > + � � � � � � � � � � V4L2_CID_AUDIO_MUTE, 0, 1, 1, 0);
>> > >
>> > > � � � v4l2_ctrl_new_std(&fmdev->ctrl_handler, &fm_ctrl_ops,
>> > > � � � � � � � � � � � V4L2_CID_RDS_TX_PI, 0x0, 0xffff, 1, 0x0);
>> > >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at �http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at �http://vger.kernel.org/majordomo-info.html



-- 
Regards
Halli
