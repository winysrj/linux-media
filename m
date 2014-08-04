Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1081 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaHDJN4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 05:13:56 -0400
Message-ID: <53DF4EC6.70009@xs4all.nl>
Date: Mon, 04 Aug 2014 11:13:42 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jean-Marc VOLLE <jean-marc.volle@st.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Divneil Rai WADHAWAN <divneil.wadhawan@st.com>
Subject: Re: [PATCH] ITU BT2020 support in v4l2_colorspace
References: <1406905371-17609-1-git-send-email-jean-marc.volle@st.com> <53DBADBD.7060407@xs4all.nl> <1BBEE2BA50AFBB41BDCE56494A11093A0111169DDEA3@SAFEX1MAIL2.st.com> <53DBC215.3070006@xs4all.nl> <1BBEE2BA50AFBB41BDCE56494A11093A011116AA6852@SAFEX1MAIL2.st.com>
In-Reply-To: <1BBEE2BA50AFBB41BDCE56494A11093A011116AA6852@SAFEX1MAIL2.st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/04/2014 10:49 AM, Jean-Marc VOLLE wrote:
> Hello Hans.
>> So it is actually being used by studios to create 4k video?
> 
> I do not know if studios are using BT2020 to create 4K video as I do not
> work for a studio. On the silicon vendor side (decoder) we need to be ready to support
> any format/color space that would become mainstream when broadcaster start
> using 4K. It may happen that all broadcasters do not use the same "encoding" as
> HEVC may be used to transport 4K content but also HD content with lower
> bandwidth requirements. We could even see some 4K 10 bits 709. My guess
> is that broadcasters will use the tools that enable the maximum of viewers
> audience taking into account the amount of capable receiver/TV at the
> time the broadcast starts.
> 
>> That's no problem. If you look at the v4l2 spec you'll see a pile of vendor
>> specific pixel formats. As long as the format is also documented in the spec,
>>  then you're OK.
> 
> I'm wondering if is makes sense to patch for BT2020 and associated vendor
> specific format only if we do not upstream the relevant driver? What is your view
> on this knowing that up streamed driver (if any) would come much later.

The vendor specific format will not be allowed upstream if there is no driver that
uses it upstream as well.

For the colorspace I am undecided. Support for it could be added to existing drivers
(adv7604), and it is part of the HDMI standard as well. Personally I would like to
add support for all colorspaces used in the HDMI standard, but I'm not sure if/when
I have the time to do that.

> 
> 
>> Colorspace is an independent property of the pixel format. The main
>> thing that is missing in V4L2 is a way to report whether full or
>> limited range quantization was used. Currently RGB pixel formats
>> are assumed to be full range and ycbcr (aka yuv) are limited range.
>> But that really should be signalled.
> 
> Do you mean there is some ongoing discussions on making independent
> color space, pixel format range and bit depth? I have seen this issue
> for HDMI (1.4) where the standard allows independant coding for color
> space, range (reduce/full) and bit depth.

I wouldn't call it a discussion, it's just something I realized when I was
recently working on colorspaces: the quantization range is currently implied
by the pixel format (RGB pixel formats expect full range, YCbCr expect limited
range), which is wrong. These are independent properties and a way is needed
to signal that. But all drivers currently follow that expectation, so it is
not an issue yet.

> 
>> For the 3.17 kernel we made it possible to extend v4l2_pix_format. See the priv field description here:
> 
>> http://hverkuil.home.xs4all.nl/spec/media.html#v4l2-pix-format
> 
> Two question here:
> - Dumb one: is http://hverkuil.home.xs4all.nl/spec/media.html the same than: http://linuxtv.org/downloads/v4l-dvb-apis/index.html

The first one is built daily, so it is always up to date. And it is a single page which I prefer.

> - I thought http://linuxtv.org/downloads/v4l-dvb-apis/index.html is always aligned to the latest release kernel (3.16) but it is already
> documenting the newly added v4l2_pix_format.flags Is it an error or my understanding of the documentation state vs kernel release 
> state is wrong?

I'm not sure when the linuxtv.org documentation is updated, but it seems to track the media_tree.git master
branch and not last released kernel.

Regards,

	Hans

> 
> Regards.
> JM
> 
> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl] 
> Sent: vendredi 1 août 2014 18:37
> To: Jean-Marc VOLLE; linux-media@vger.kernel.org
> Cc: Divneil Rai WADHAWAN
> Subject: Re: [PATCH] ITU BT2020 support in v4l2_colorspace
> 
> On 08/01/2014 05:54 PM, Jean-Marc VOLLE wrote:
>> Hello Hans,
>> Thanks for you very quick feedback, it is my first patch and I'm happy 
>> it gets some feedbacks.
>>
>>> I'm not opposed to this, but have you actually seen video streams with this colorspace?
>> I work on silicon for set top boxes and we are indeed starting testing 
>> support for BT2020 encode streams.
> 
> So it is actually being used by studios to create 4k video?
> 
>>
>>
>>> More to the point, this colorspace is only valid for 10 and 12 bit 
>>> deep colors (something that should be documented as well), and I 
>>> don't think we even have PIX_FMT defines for that. Are there plans to add support for that?
>>
>> For the color space you are right, this is only valid for 10 & 12 bit 
>> deep colors and current YUV formats do not explicitly state if pixel 
>> encoding is on 8,
>> 10 or 12 bits as all formats so far used 8 bits encoding.
>>
>> We do not plan to upstream our 10 bits formats because our HW has a 
>> really fancy way of storing them and I doubt other hw vendor would do the same.
> 
> That's no problem. If you look at the v4l2 spec you'll see a pile of vendor specific pixel formats. As long as the format is also documented in the spec, then you're OK.
> 
>> ( no padding to 32 bits is performed ie the end of each YUV444 triplet 
>> starts with a new tripplet.) Our driver code "quality" is far from 
>> beeing upstremable for the time beeing so I did not think properly 
>> about "standard" 10/12 bits V4L2_PIX_FMT.
> 
> If you are interested in eventually upstreaming your code, then it's no problem to either post it to the mailinglist and ask for some initial feedback, or mail it for example to me in private. We like new drivers as we want V4L2 to be the de-facto API for video capture and hw codecs, so I'm happy to assist.
> 
>>
>> I can however propose a patch for PIX_FMT for 444, 420 and 422 10/8 
>> bits Let me know your thoughts about following naming scheme:
>>
>> reuse any existing PIX_FMT name ( eg V4L2_PIX_FMT_NV16) and extend its 
>> name with _10 or _12 on a need basis.
> 
> I would stick to your hardware specific format rather than inventing pixel formats that nobody else is using yet.
> 
>>
>> Other ways (to avoid creating a bunch of new names) could be:
>> - create 2 BT2020 entries in the color space (one for 10 bits one for 
>> 12 bits) bitdepth would be inferred by those entries (not so nice)
> 
> Colorspace is an independent property of the pixel format. The main thing that is missing in V4L2 is a way to report whether full or limited range quantization was used. Currently RGB pixel formats are assumed to be full range and ycbcr (aka yuv) are limited range. But that really should be signalled.
> 
>> - Add bit depth in v4l2_pix_format.priv
>>
>> Our current solution relies on extending the V4L2_PIX_FMT
> 
> For the 3.17 kernel we made it possible to extend v4l2_pix_format. See the priv field description here:
> 
> http://hverkuil.home.xs4all.nl/spec/media.html#v4l2-pix-format
> 
> Regards,
> 
> 	Hans
> 
>>
>> Regards.
>> JM
>>
>>
>> -----Original Message-----
>> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>> Sent: vendredi 1 août 2014 17:10
>> To: Jean-Marc VOLLE; linux-media@vger.kernel.org
>> Cc: Divneil Rai WADHAWAN
>> Subject: Re: [PATCH] ITU BT2020 support in v4l2_colorspace
>>
>> On 08/01/2014 05:02 PM, Jean-Marc VOLLE wrote:
>>> From: vollejm <jean-marc.volle@st.com>
>>>
>>> UHD video content may be encoded using a new color space (BT2020). 
>>> This patch adds it to the  v4l2_colorspace enum
>>
>> I'm not opposed to this, but have you actually seen video streams with this colorspace?
>>
>> More to the point, this colorspace is only valid for 10 and 12 bit deep colors (something that should be documented as well), and I don't think we even have PIX_FMT defines for that. Are there plans to add support for that?
>>
>> Regards,
>>
>> 	Hans
>>
>>>
>>>
>>> Signed-off-by: <jean-marc.volle@st.com>
>>> ---
>>>  Documentation/DocBook/media/v4l/biblio.xml | 10 ++++++++++ 
>>> Documentation/DocBook/media/v4l/pixfmt.xml | 14 ++++++++++++++
>>>  include/uapi/linux/videodev2.h             |  4 ++++
>>>  3 files changed, 28 insertions(+)
>>>
>>> diff --git a/Documentation/DocBook/media/v4l/biblio.xml
>>> b/Documentation/DocBook/media/v4l/biblio.xml
>>> index d2eb79e..d3930cf 100644
>>> --- a/Documentation/DocBook/media/v4l/biblio.xml
>>> +++ b/Documentation/DocBook/media/v4l/biblio.xml
>>> @@ -117,6 +117,16 @@ url="http://www.itu.ch">http://www.itu.ch</ulink>)</corpauthor>
>>>        <title>ITU-R Recommendation BT.1119 "625-line  television Wide 
>>> Screen Signalling (WSS)"</title>
>>>      </biblioentry>
>>> +    <biblioentry id="itu2020">
>>> +      <abbrev>ITU&nbsp;BT.2020</abbrev>
>>> +      <authorgroup>
>>> +	<corpauthor>International Telecommunication Union (<ulink 
>>> +url="http://www.itu.ch">http://www.itu.ch</ulink>)</corpauthor>
>>> +      </authorgroup>
>>> +      <title>ITU-R Recommendation BT.2020 "Parameter values for
>>> +	      ultra-high definition television systems for production
>>> +	      and international programme exchange"</title>
>>> +    </biblioentry>
>>>  
>>>      <biblioentry id="jfif">
>>>        <abbrev>JFIF</abbrev>
>>> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml
>>> b/Documentation/DocBook/media/v4l/pixfmt.xml
>>> index 91dcbc8..f0c70dd 100644
>>> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
>>> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
>>> @@ -599,6 +599,20 @@ are still clamped to [0;255].</para> 
>>> 1.099&nbsp;I<superscript>0.45</superscript>&nbsp;-&nbsp;0.099&nbsp;for&nbsp;0.018&nbsp;&lt;&nbsp;I</entry>
>>>  	    <entry spanname="spam">n/a</entry>
>>>  	  </row>
>>> +	  <row>
>>> +	    <entry><constant>V4L2_COLORSPACE_BT2020</constant></entry>
>>> +	    <entry>9</entry>
>>> +	    <entry>BT2020, see <xref linkend="itu2020" /></entry>
>>> +	    <entry>x&nbsp;=&nbsp;0.708, y&nbsp;=&nbsp;0.292</entry>
>>> +	    <entry>x&nbsp;=&nbsp;0.170, y&nbsp;=&nbsp;0.797</entry>
>>> +	    <entry>x&nbsp;=&nbsp;0.131, y&nbsp;=&nbsp;0.046</entry>
>>> +	    <entry>x&nbsp;=&nbsp;0.3127, y&nbsp;=&nbsp;0.3290,
>>> +	    Illuminant D<subscript>65</subscript></entry>
>>> +	    <entry>see <xref linkend="itu2020" /></entry>
>>> +	    <entry>see <xref linkend="itu2020" /></entry>
>>> +	    <entry>see <xref linkend="itu2020" /></entry>
>>> +	    <entry>see <xref linkend="itu2020" /></entry>
>>> +	  </row>
>>>  	</tbody>
>>>        </tgroup>
>>>      </table>
>>> diff --git a/include/uapi/linux/videodev2.h 
>>> b/include/uapi/linux/videodev2.h index 168ff50..6af06e1 100644
>>> --- a/include/uapi/linux/videodev2.h
>>> +++ b/include/uapi/linux/videodev2.h
>>> @@ -197,6 +197,10 @@ enum v4l2_colorspace {
>>>  
>>>  	/* For RGB colourspaces, this is probably a good start. */
>>>  	V4L2_COLORSPACE_SRGB          = 8,
>>> +
>>> +	/* UHD BT2020 colorspace */
>>> +	V4L2_COLORSPACE_BT2020          = 9,
>>> +
>>>  };
>>>  
>>>  enum v4l2_priority {
>>>
>>
> 

