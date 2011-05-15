Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:30009 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686Ab1EOPT7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 May 2011 11:19:59 -0400
Message-ID: <4DCFEFD2.3090704@maxwell.research.nokia.com>
Date: Sun, 15 May 2011 18:22:58 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH 1/1] v4l: Document EACCES in VIDIOC_G_CTRL and VIDIOC_G_EXT_CTRLS
References: <1305293053-16448-1-git-send-email-sakari.ailus@maxwell.research.nokia.com> <201105150950.37107.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105150950.37107.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent Pinchart wrote:
> Hi Sakari,

Hi, Laurent!

Thanks for the comments!

> On Friday 13 May 2011 15:24:13 Sakari Ailus wrote:
>> VIDIOC_G_CTRL and VIDIOC_G_EXT_CTRLS return EACCES when setting a read-only
>> control or getting a write-only control.  Document this.
> 
> You might want to modify the commit message to include VIDIOC_S_CTRL and 
> VIDIOC_S_EXT_CTRLS. Setting a control with the VIDIOC_G_(EXT_)CTRL(S) ioctls 
> is a bit difficult :-)

I'll do that. I was thinking of the documentation when reading this, not
the actual ioctls. ;-)

>> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
>> ---
>>  Documentation/DocBook/v4l/vidioc-g-ctrl.xml      |    7 +++++++
>>  Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml |    7 +++++++
>>  2 files changed, 14 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/DocBook/v4l/vidioc-g-ctrl.xml
>> b/Documentation/DocBook/v4l/vidioc-g-ctrl.xml index 8b5e6ff..5146d00
>> 100644
>> --- a/Documentation/DocBook/v4l/vidioc-g-ctrl.xml
>> +++ b/Documentation/DocBook/v4l/vidioc-g-ctrl.xml
>> @@ -117,6 +117,13 @@ because another applications took over control of the
>> device function this control belongs to.</para>
>>  	</listitem>
>>        </varlistentry>
>> +      <varlistentry>
>> +	<term><errorcode>EACCES</errorcode></term>
>> +	<listitem>
>> +	  <para>Attempt to set a read-only control or to get a
>> +	  write-only control.</para>
> 
> Should you s/set/try or set/ ?

No, since you can only try controls using the TRY_EXT_CTRLS. There is no
VIDIOC_TRY_CTRL.

>> +	</listitem>
>> +      </varlistentry>
>>      </variablelist>
>>    </refsect1>
>>  </refentry>
>> diff --git a/Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml
>> b/Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml index 3aa7f8f..5e73517
>> 100644
>> --- a/Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml
>> +++ b/Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml
>> @@ -294,6 +294,13 @@ The field <structfield>size</structfield> is set to a
>> value that is enough to store the payload and this error code is
>> returned.</para>
>>  	</listitem>
>>        </varlistentry>
>> +      <varlistentry>
>> +	<term><errorcode>EACCES</errorcode></term>
>> +	<listitem>
>> +	  <para>Attempt to try or set a read-only control or to get a
>> +	  write-only control.</para>
>> +	</listitem>
>> +      </varlistentry>
>>      </variablelist>
>>    </refsect1>
>>  </refentry>
> 


-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
