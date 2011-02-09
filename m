Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46394 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab1BISpN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 13:45:13 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=0-GWXGHLOAf5vvx6bL=wjYpSMF=Z5Q=jLzE06@mail.gmail.com>
References: <1297157427-14560-1-git-send-email-t.stanislaws@samsung.com>
	<201102081047.17840.hansverk@cisco.com>
	<AANLkTi=A=HiAvHojWP8HcFXpjXbZpq6UdHjOnWq-8jww@mail.gmail.com>
	<201102090959.29732.hansverk@cisco.com>
	<AANLkTi=0-GWXGHLOAf5vvx6bL=wjYpSMF=Z5Q=jLzE06@mail.gmail.com>
Date: Wed, 9 Feb 2011 10:45:12 -0800
Message-ID: <AANLkTimA4kpfSgJQyoLCfp7wemixYrB5pd-j2ntpobKP@mail.gmail.com>
Subject: Re: [PATCH/RFC 0/5] HDMI driver for Samsung S5PV310 platform
From: Corbin Simpson <mostawesomedude@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Hans Verkuil <hansverk@cisco.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	Maling list - DRI developers
	<dri-devel@lists.freedesktop.org>, kyungmin.park@samsung.com,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Feb 9, 2011 at 9:55 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
> On Wed, Feb 9, 2011 at 3:59 AM, Hans Verkuil <hansverk@cisco.com> wrote:
>> On Tuesday, February 08, 2011 16:28:32 Alex Deucher wrote:
>>> On Tue, Feb 8, 2011 at 4:47 AM, Hans Verkuil <hansverk@cisco.com> wrote:
>>
>> <snip>
>>
>>> >>   The driver supports an interrupt. It is used to detect plug/unplug
>> events
>>> > in
>>> >> kernel debugs.  The API for detection of such an events in V4L2 API is to
>> be
>>> >> defined.
>>> >
>>> > Cisco (i.e. a few colleagues and myself) are working on this. We hope to
>> post
>>> > an RFC by the end of this month. We also have a proposal for CEC support
>> in
>>> > the pipeline.
>>>
>>> Any reason to not use the drm kms APIs for modesetting, display
>>> configuration, and hotplug support?  We already have the
>>> infrastructure in place for complex display configurations and
>>> generating events for hotplug interrupts.  It would seem to make more
>>> sense to me to fix any deficiencies in the KMS APIs than to spin a new
>>> API.  Things like CEC would be a natural fit since a lot of desktop
>>> GPUs support hdmi audio/3d/etc. and are already using kms.
>>
>> There are various reasons for not going down that road. The most important one
>> is that mixing APIs is actually a bad idea. I've done that once in the past
>> and I've regretted ever since. The problem with doing that is that it is
>> pretty hard on applications who have to mix two different styles of API,
>> somehow know where to find the documentation for each and know that both APIs
>> can in fact be used on the same device.
>>
>> Now, if there was a lot of code that could be shared, then that might be
>> enough reason to go that way, but in practice there is very little overlap.
>> Take CEC: all the V4L API will do is to pass the CEC packets from kernel to
>> userspace and vice versa. There is no parsing at all. This is typically used
>> by embedded apps that want to do their own CEC processing.
>>
>> An exception might be a PCI(e) card with HDMI input/output that wants to
>> handle CEC internally. At that point we might look at sharing CEC parsing
>> code. A similar story is true for EDID handling.
>>
>> One area that might be nice to look at would be to share drivers for HDMI
>> receivers and transmitters. However, the infrastructure for such drivers is
>> wildly different between how it is used for GPUs versus V4L and has been for
>> 10 years or so. I also suspect that most GPUs have there own HDMI internal
>> implementation so code sharing will probably be quite limited.
>>
>
> You don't need to worry about the rest of the 3D and acceleration
> stuff to use the kms modesetting API.  For video output, you have a
> timing generator, an encoder that translates a bitstream into
> voltages, and an connector that you plug into a monitor.  Additionally
> you may want to read an edid or generate a hotplug event and use some
> modeline handling helpers.  The kms api provides core modesetting code
> and a set of modesetting driver callbacks for crtcs, encoders, and
> connectors.  The hardware implementations will vary, but modesetting
> is the same.  From drm_crtc_helper.h:
>
> The driver provides the following callbacks for the crtc.  The crtc
> loosely refers to the part of the display pipe that generates timing
> and framebuffer scanout position.
>
> struct drm_crtc_helper_funcs {
>        /*
>         * Control power levels on the CRTC.  If the mode passed in is
>         * unsupported, the provider must use the next lowest power
> level.
>         */
>        void (*dpms)(struct drm_crtc *crtc, int mode);
>        void (*prepare)(struct drm_crtc *crtc);
>        void (*commit)(struct drm_crtc *crtc);
>
>        /* Provider can fixup or change mode timings before modeset occurs */
>        bool (*mode_fixup)(struct drm_crtc *crtc,
>                           struct drm_display_mode *mode,
>                           struct drm_display_mode *adjusted_mode);
>        /* Actually set the mode */
>        int (*mode_set)(struct drm_crtc *crtc, struct drm_display_mode *mode,
>                        struct drm_display_mode *adjusted_mode, int x, int y,
>                        struct drm_framebuffer *old_fb);
>
>        /* Move the crtc on the current fb to the given position *optional* */
>        int (*mode_set_base)(struct drm_crtc *crtc, int x, int y,
>                             struct drm_framebuffer *old_fb);
>        int (*mode_set_base_atomic)(struct drm_crtc *crtc,
>                                    struct drm_framebuffer *fb, int x, int y,
>                                    enum mode_set_atomic);
>
>        /* reload the current crtc LUT */
>        void (*load_lut)(struct drm_crtc *crtc);
>
>        /* disable crtc when not in use - more explicit than dpms off */
>        void (*disable)(struct drm_crtc *crtc);
> };
>
> encoders take the bitstream from the crtc and convert it into a set of
> voltages understood by the monitor, e.g., TMDS or LVDS encoders.  The
> callbacks follow a similar pattern to crtcs.
>
> struct drm_encoder_helper_funcs {
>        void (*dpms)(struct drm_encoder *encoder, int mode);
>        void (*save)(struct drm_encoder *encoder);
>        void (*restore)(struct drm_encoder *encoder);
>
>        bool (*mode_fixup)(struct drm_encoder *encoder,
>                           struct drm_display_mode *mode,
>                           struct drm_display_mode *adjusted_mode);
>        void (*prepare)(struct drm_encoder *encoder);
>        void (*commit)(struct drm_encoder *encoder);
>        void (*mode_set)(struct drm_encoder *encoder,
>                         struct drm_display_mode *mode,
>                         struct drm_display_mode *adjusted_mode);
>        struct drm_crtc *(*get_crtc)(struct drm_encoder *encoder);
>        /* detect for DAC style encoders */
>        enum drm_connector_status (*detect)(struct drm_encoder *encoder,
>                                            struct drm_connector *connector);
>        /* disable encoder when not in use - more explicit than dpms off */
>        void (*disable)(struct drm_encoder *encoder);
> };
>
>
> And finally connectors.  These are the actual physical connectors on
> the board (DVI-I, HDMI-A, VGA, S-video, etc.).  Things like ddc lines
> are generally tied to a connector so functions relevant to getting
> modelines are associated with connectors.
>
> struct drm_connector_helper_funcs {
>        int (*get_modes)(struct drm_connector *connector);
>        int (*mode_valid)(struct drm_connector *connector,
>                          struct drm_display_mode *mode);
>        struct drm_encoder *(*best_encoder)(struct drm_connector *connector);
> };
>
> See drm_crtc_helper.c to see how the callbacks are used.  The code can
> handle crtcs that can be routed to different encoders dynamically or
> crtcs that are hardcoded to specific encoders.  Additionally, it can
> handle encoders that are shared between multiple connectors (e.g., a
> DAC shared between VGA and S-video), or multiple encoders tied to a
> single connector (e.g., DAC and TMDS encoders tied to a single DVI-I
> connector).
>
> Let's look at two scenarios where you want a system to display an
> interactive RGB desktop and provide video capture and video output.
> You'd need to use different sets of APIs depending on what hardware
> you use:
>
> 1. SoC with an LVDS panel and HDMI output and a capture unit
> 2. PC with a GPU with an LVDS panel and an HDMI output and a capture unit.
>
> As I understand it, to use the scenario 1 would use the following:
>
> - LVDS uses some new v4l interface or a hacked up kernel fb interface
> to support multiple displays
> - HDMI uses some new v4l interface or a hacked up kernel fb interface
> to support multiple displays
> - capture unit uses V4L
>
> Scenario 2 would use:
>
> - LVDS uses KMS API
> - HDMI uses KMS API
> - capture unit uses V4L
>
> Why not use KMS?  A modesetting API is a huge amount of work.  I
> haven't seen anything in these SoC platforms that makes them so
> radically different that they need their own API.  If there are any,
> we'd love to hear about them so they can be addressed.
>
> Alex
>
>> So, no, there are no plans to share anything between the two (except perhaps
>> EDID and CEC parsing should that become relevant).
>>
>> Oh, and let me join Andy in saying that the drm/kms/whatever API documentation
>> *really* needs a lot of work.

I know this is sort of a "me too" as none of my code's upstream yet,
but the barrier posed by the lack of documentation for KMS is
*massive* since the only KMS drivers are for highly complex pieces of
hardware, making them difficult to read. The entire KMS API can be
implemented in a single C file for simple hardware, just like the FB
API, but you'd never know it by looking at the existing drivers.

~ C.

-- 
When the facts change, I change my mind. What do you do, sir? ~ Keynes

Corbin Simpson
<MostAwesomeDude@gmail.com>
