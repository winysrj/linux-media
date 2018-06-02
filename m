Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35707 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751802AbeFBW4u (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2018 18:56:50 -0400
Subject: Re: [RFC PATCH v2 1/2] drm: Add generic colorkey properties
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        Russell King <linux@armlinux.org.uk>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20180526155623.12610-1-digetx@gmail.com>
 <20180526155623.12610-2-digetx@gmail.com> <20180529071742.GM23723@intel.com>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <b7d985dc-84de-2243-80dd-02a1571a02b6@gmail.com>
Date: Sun, 3 Jun 2018 01:56:46 +0300
MIME-Version: 1.0
In-Reply-To: <20180529071742.GM23723@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29.05.2018 10:17, Ville Syrjälä wrote:
> On Sat, May 26, 2018 at 06:56:22PM +0300, Dmitry Osipenko wrote:
>> Color keying is the action of replacing pixels matching a given color
>> (or range of colors) with transparent pixels in an overlay when
>> performing blitting. Depending on the hardware capabilities, the
>> matching pixel can either become fully transparent or gain adjustment
>> of the pixels component values.
>>
>> Color keying is found in a large number of devices whose capabilities
>> often differ, but they still have enough common features in range to
>> standardize color key properties. This commit adds nine generic DRM plane
>> properties related to the color keying to cover various HW capabilities.
>>
>> This patch is based on the initial work done by Laurent Pinchart, most of
>> credits for this patch goes to him.
>>
>> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
>> ---
>>  drivers/gpu/drm/drm_atomic.c |  36 ++++++
>>  drivers/gpu/drm/drm_blend.c  | 229 +++++++++++++++++++++++++++++++++++
>>  include/drm/drm_blend.h      |   3 +
>>  include/drm/drm_plane.h      |  77 ++++++++++++
>>  4 files changed, 345 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
>> index 895741e9cd7d..5b808cb68654 100644
>> @@ -124,6 +175,19 @@ struct drm_plane_state {
>>  	unsigned int zpos;
>>  	unsigned int normalized_zpos;
>>  
>> +	/* Plane colorkey */
>> +	struct {
>> +		enum drm_plane_colorkey_mode mode;
>> +		u64 min;
>> +		u64 max;
>> +		u64 mask;
>> +		u32 format;
>> +		bool inverted_match;
>> +		u64 replacement_mask;
>> +		u64 replacement_value;
>> +		u32 replacement_format;
>> +	} colorkey;
> 
> After a quick stab at implementing this for i915 I came to the
> conclusion that I'd like this struct to have a name so that I can pass
> it around/consult it easily without having to mess about with the entire
> plane state.
> 
> One extra question that came up is how are we going to define the
> destination color key? Is it to be a) enabled on the plane that has the
> colorkey painted on it, or is it to be b) enabled on a plane that sits
> above the plane that is going to be covering up the colorkey? Modern
> Intel hardware defines it the a) way, whereas older hw used the b)
> method. Thinking about it I do think the a) method seems nicer because
> it removes the ambiguity as to which plane's pixels are going to be
> compared again the colorkey. So kinda matches the src colorkey case
> better.
> 
> Oh and this also brings up the question as to which other plane(s) are
> taking part in the colorkey process. Looks like on modern Intel hw it's
> supposed to be just the plane immediately above the plane with
> dst keying enabled. On some really old hw there were some more
> complicated rules as to which pair of planes are involved. On middle
> aged hw the situation is simpler a there are only ever two
> (non-cursor) planes on the same crtc. The cursor doesn't seem to
> participate in the colorkeing ever. Not sure there's a sane way to
> fully abstract this all.
> 
> I should probably poke at the hardware a bit more to figure out how
> this really works when there are more than two active planes on the
> crtc. <day later> I did poke at one particular class of hw which is
> a bit of a mix of old and middle aged hw, and there it seems I can
> also do dst colorkeying the a) way. And in this case there are three
> planes taking part in the dst colorkey match (the primary that
> has the colorkey painted on it, and two overlay planes that cover
> up the matched pixels). So for that case definitely the a) approach
> in the uapi would make more sense as trying to specify conflicting
> dst colorkey settings for each of the overlay planes wouldn't make
> any sense. I'll need to poke at the modern hw a bit more still...
> 

Color keying mode must explicitly define the expected behavior. It is up to a
driver to enable HW color keying for an appropriate plane, or whatever needs to
be done to provide the behavior.

After some more considering, I've reduced the color keying properties and modes
to a bare-and-practical minimum, also taking into account your comments. I'll
send out a new version of the patch later today, let's continue discussion there.
