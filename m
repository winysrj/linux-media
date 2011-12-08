Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48129 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab1LHDmO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 22:42:14 -0500
MIME-Version: 1.0
In-Reply-To: <4EDD428B.9010800@gmail.com>
References: <1322838172-11149-1-git-send-email-ming.lei@canonical.com>
	<1322838172-11149-6-git-send-email-ming.lei@canonical.com>
	<4EDD428B.9010800@gmail.com>
Date: Thu, 8 Dec 2011 11:42:10 +0800
Message-ID: <CACVXFVMR_n946HW1eYWEfcig_D6wFx5e3vEKmVHtERcmtsXX6g@mail.gmail.com>
Subject: Re: [RFC PATCH v1 5/7] media: v4l2: introduce two IOCTLs for face detection
From: Ming Lei <ming.lei@canonical.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, Dec 6, 2011 at 6:15 AM, Sylwester Nawrocki <snjw23@gmail.com> wrote:
> On 12/02/2011 04:02 PM, Ming Lei wrote:
>> This patch introduces two new IOCTLs and related data
>> structure defination which will be used by the coming
>> face detection video device.
>>
>> The two IOCTLs and related data structure are used by
>> user space application to retrieve the results of face
>> detection. They can be called after one v4l2_buffer
>> has been ioctl(VIDIOC_DQBUF) and before it will be
>> ioctl(VIDIOC_QBUF).
>>
>> The utility fdif[1] is useing the two IOCTLs to find
>> faces deteced in raw images or video streams.
>>
>> [1],http://kernel.ubuntu.com/git?p=ming/fdif.git;a=shortlog;h=refs/heads/v4l2-fdif
>>
>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>> ---
>> �drivers/media/video/v4l2-ioctl.c | � 38 ++++++++++++++++++++
>> �include/linux/videodev2.h � � � �| � 70 ++++++++++++++++++++++++++++++++++++++
>> �include/media/v4l2-ioctl.h � � � | � �6 +++
>> �3 files changed, 114 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
>> index e1da8fc..fc6266f 100644
>> --- a/drivers/media/video/v4l2-ioctl.c
>> +++ b/drivers/media/video/v4l2-ioctl.c
>> @@ -2140,6 +2140,30 @@ static long __video_do_ioctl(struct file *file,
>> � � � � � � � dbgarg(cmd, "index=%d", b->index);
>> � � � � � � � break;
>> � � � }
>> + � � case VIDIOC_G_FD_RESULT:
>> + � � {
>> + � � � � � � struct v4l2_fd_result *fr = arg;
>> +
>> + � � � � � � if (!ops->vidioc_g_fd_result)
>> + � � � � � � � � � � break;
>> +
>> + � � � � � � ret = ops->vidioc_g_fd_result(file, fh, fr);
>> +
>> + � � � � � � dbgarg(cmd, "index=%d", fr->buf_index);
>> + � � � � � � break;
>> + � � }
>> + � � case VIDIOC_G_FD_COUNT:
>> + � � {
>> + � � � � � � struct v4l2_fd_count *fc = arg;
>> +
>> + � � � � � � if (!ops->vidioc_g_fd_count)
>> + � � � � � � � � � � break;
>> +
>> + � � � � � � ret = ops->vidioc_g_fd_count(file, fh, fc);
>> +
>> + � � � � � � dbgarg(cmd, "index=%d", fc->buf_index);
>> + � � � � � � break;
>> + � � }
>> � � � default:
>> � � � � � � � if (!ops->vidioc_default)
>> � � � � � � � � � � � break;
>> @@ -2234,6 +2258,20 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
>> � � � � � � � }
>> � � � � � � � break;
>> � � � }
>> +
>> + � � case VIDIOC_G_FD_RESULT: {
>> + � � � � � � struct v4l2_fd_result *fr = parg;
>> +
>> + � � � � � � if (fr->face_cnt != 0) {
>> + � � � � � � � � � � *user_ptr = (void __user *)fr->fd;
>> + � � � � � � � � � � *kernel_ptr = (void *)&fr->fd;
>> + � � � � � � � � � � *array_size = sizeof(struct v4l2_fd_detection)
>> + � � � � � � � � � � � � � � � � * fr->face_cnt;
>> + � � � � � � � � � � ret = 1;
>> + � � � � � � }
>> + � � � � � � break;
>> +
>> + � � }
>> � � � }
>>
>> � � � return ret;
>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>> index 4b752d5..073eb4d 100644
>> --- a/include/linux/videodev2.h
>> +++ b/include/linux/videodev2.h
>> @@ -2160,6 +2160,74 @@ struct v4l2_create_buffers {
>> � � � __u32 � � � � � � � � � reserved[8];
>> �};
>>
>> +/**
>> + * struct v4l2_obj_detection
>> + * @buf_index: � � � entry, index of v4l2_buffer for face detection
>> + * @centerx: return, position in x direction of detected object
>> + * @centery: return, position in y direction of detected object
>> + * @angle: � return, angle of detected object
>> + * � � � � � 0 deg ~ 359 deg, vertical is 0 deg, clockwise
>> + * @sizex: � return, size in x direction of detected object
>> + * @sizey: � return, size in y direction of detected object
>> + * @confidence: � � �return, confidence level of detection result
>> + * � � � � � 0: the heighest level, 9: the lowest level
>
> Hmm, not a good idea to align a public interface to the capabilities
> of a single hardware implementation.

I think that the current omap interface is general enough, so why can't
we use it as public interface?

> min/max confidence could be queried with
> relevant controls and here we could remove the line implying range.

No, the confidence is used to describe the probability about
the correctness of the current detection result. Anyway, no FD can
make sure that it is 100% correct.  Other HW can normalize its
confidence level to 0~9 so that application can handle it easily, IMO.

>> + * @reserved: � � � �future extensions
>> + */
>> +struct v4l2_obj_detection {
>> + � � __u16 � � � � � centerx;
>> + � � __u16 � � � � � centery;
>> + � � __u16 � � � � � angle;
>> + � � __u16 � � � � � sizex;
>> + � � __u16 � � � � � sizey;
>
> How about using struct v4l2_rect in place of centerx/centery, sizex/sizey ?
> After all it describes a rectangle. We could also use struct v4l2_frmsize_discrete
> for size but there seems to be missing en equivalent for position, e.g.

Maybe user space would like to plot a circle or ellipse over the detected
objection, and I am sure that I have seen this kind of plot over detected
face before.

> struct v4l2_position {
> � � � �__s32 x;
> � � � �__s32 y;
> };
>
>> + � � __u16 � � � � � confidence;
>> + � � __u32 � � � � � reserved[4];
>> +};
>> +
>> +#define V4L2_FD_HAS_LEFT_EYE 0x1
>> +#define V4L2_FD_HAS_RIGHT_EYE � � � �0x2
>> +#define V4L2_FD_HAS_MOUTH � �0x4
>> +#define V4L2_FD_HAS_FACE � � 0x8
>> +
>> +/**
>> + * struct v4l2_fd_detection - VIDIOC_G_FD_RESULT argument
>> + * @flag: � �return, describe which objects are detected
>> + * @left_eye: � � � �return, left_eye position if detected
>> + * @right_eye: � � � return, right_eye position if detected
>> + * @mouth_eye: � � � return, mouth_eye position if detected
>
> mouth_eye ? ;)

Sorry, it should be mouth, :-)

>
>> + * @face: � �return, face position if detected
>> + */
>> +struct v4l2_fd_detection {
>> + � � __u32 � flag;
>> + � � struct v4l2_obj_detection � � � left_eye;
>> + � � struct v4l2_obj_detection � � � right_eye;
>> + � � struct v4l2_obj_detection � � � mouth;
>> + � � struct v4l2_obj_detection � � � face;
>
> I would do this differently, i.e. put "flag" inside struct v4l2_obj_detection
> and then struct v4l2_fd_detection would be simply an array of
> struct v4l2_obj_detection, i.e.
>
> struct v4l2_fd_detection {
> � � � �unsigned int count;
> � � � �struct v4l2_obj_detection [V4L2_MAX_FD_OBJECT_NUM];
> };
>
> This might be more flexible, e.g. if in the future some hardware supports
> detecting wrinkles, we could easily add that by just defining a new flag:
> V4L2_FD_HAS_WRINKLES, etc.

This is a bit flexible, but not explicit enough for describing
interface, how about
reserving these as below for future usage?

	struct v4l2_fd_detection {
		__u32   flag;
		Struct v4l2_obj_detection       left_eye;
		Struct v4l2_obj_detection       right_eye;
		Struct v4l2_obj_detection       mouth;
		Struct v4l2_obj_detection       face;
		Struct v4l2_obj_detection       reserved[4];
	};


thanks,
--
Ming Lei
