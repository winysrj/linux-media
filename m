Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway13.websitewelcome.com ([67.18.82.4])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1KZDfm-00049B-M8
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 01:46:35 +0200
Message-ID: <48B88A54.1010200@kipdola.com>
Date: Sat, 30 Aug 2008 01:46:28 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
References: <20080821173909.114260@gmx.net>	<37219a840808290852k4cafb891tbf35162d3add6d60@mail.gmail.com>	<20080829164352.74800@gmx.net>	<200808292052.51219@orion.escape-edv.de>
	<48B84AD0.8010209@gmail.com>
In-Reply-To: <48B84AD0.8010209@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Future of DVB-S2
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1153022888=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1153022888==
Content-Type: multipart/alternative;
 boundary="------------050003070002000609050908"

This is a multi-part message in MIME format.
--------------050003070002000609050908
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Wait, where are you going to merge the multiproto drivers to? Am I 
reading it correct that you'll get them in the dvb-4vl tree or.. What am 
I missing here? :)

This has been one hell of a day!

/Met vriendelijke groeten,/

*Jelle De Loecker*
Kipdola Studios - Tomberg 


Manu Abraham schreef:
> Oliver Endriss wrote:
>   
>> Hans Werner wrote:
>>     
>>>>> Now, to show how simple I think all this could be, here is a PATCH
>>>>>           
>>>> implementing what
>>>>         
>>>>> I think is the *minimal* API required to support DVB-S2.
>>>>>
>>>>> Notes:
>>>>>
>>>>> * same API structure, I just added some new enums and variables, nothing
>>>>>           
>>>> removed
>>>>         
>>>>> * no changes required to any existing drivers (v4l-dvb still compiles)
>>>>> * no changes required to existing applications (just need to be
>>>>>           
>>>> recompiled)
>>>>         
>>>>> * no drivers, but I think the HVR4000 MFE patch could be easily adapted
>>>>>
>>>>> I added the fe_caps2 enum because we're running out of bits in the
>>>>>           
>>>> capabilities bitfield.
>>>>         
>>>>> More elegant would be to have separate bitfields for FEC capabilities
>>>>>           
>>>> and modulation
>>>>         
>>>>> capabilities but that would require (easy) changes to (a lot of) drivers
>>>>>           
>>>> and applications.
>>>>         
>>>>> Why should we not merge something simple like this immediately? This
>>>>>           
>>>> could have been done
>>>>         
>>>>> years ago. If it takes several rounds of API upgrades to reach all the
>>>>>           
>>>> feature people want then
>>>>         
>>>>> so be it, but a long journey begins with one step.
>>>>>           
>>>> This will break binary compatibility with existing apps.  You're right
>>>> -- those apps will work with a recompile, but I believe that as a
>>>> whole, the linux-dvb kernel and userspace developers alike are looking
>>>> to avoid breaking binary compatibility.
>>>>         
>>> Michael,
>>> thank you for your comment.
>>>
>>> I understand, but I think binary compatibility *should* be broken in this case. It makes
>>> everything else simpler.
>>>       
>> No way. Breaking binary compatibility is a no-go.
>>
>>     
>>> I know that not breaking binary compatibility *can* be done (as in the HVR4000 SFE and
>>> MFE patches) but at what cost?  The resulting code is very odd. Look at multiproto which 
>>> bizarrely implements both the 3.2 and the 3.3 API and a compatibility layer as well, at huge cost
>>> in terms of development time and complexity of understanding. The wrappers used in the MFE
>>> patches are a neat and simple trick, but not something you would release in the kernel.
>>>       
>> The only way to support DVB-S2 in a reasonable way is adding a new API.
>> Multiproto does this.
>>
>>     
>>> If you take the position the binary interface cannot *ever* change then you are severely
>>> restricting the changes that can be made and you doom yourself to an API that is no longer
>>> suited to the job. And the complexity kills. As we have seen, it makes the whole process grind to a
>>> halt. 
>>>
>>> Recompilation is not a big deal. All distros recompile every application for each release (in fact much more frequently -- updates too), so most users will never even notice.  It is much better to make the right, elegant changes to the API and require a recompilation. It's better for the application developers because they get a sane evolution of the API and can more easily add new features. Anyone who
>>> really cannot recompile existing userspace binaries will also have plenty of other restrictions and
>>> should not be trying to drop a new kernel into a fixed userspace.
>>>       
>> The linux distribution maintainers would kill you.
>> Applications must continue to run after a kernel update.
>>
>>     
>>> I would be interested to hear your opinion on how we can move forward rapidly.
>>>       
>> Multiproto should be merged asap.
>>     
>
>
> True. Sorry about the long delay, just got back after quite a long
> journey. Will do so these following days.
>
> Regards,
> Manu
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   

--------------050003070002000609050908
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
Wait, where are you going to merge the multiproto drivers to? Am I
reading it correct that you'll get them in the dvb-4vl tree or.. What
am I missing here? :)<br>
<br>
This has been one hell of a day!<br>
<div class="moz-signature"><br>
<em>Met vriendelijke groeten,</em>
<br>
<br>
<strong>Jelle De Loecker</strong>
<br>
Kipdola Studios - Tomberg&nbsp;</div>
<br>
<br>
Manu Abraham schreef:
<blockquote cite="mid:48B84AD0.8010209@gmail.com" type="cite">
  <pre wrap="">Oliver Endriss wrote:
  </pre>
  <blockquote type="cite">
    <pre wrap="">Hans Werner wrote:
    </pre>
    <blockquote type="cite">
      <blockquote type="cite">
        <blockquote type="cite">
          <pre wrap="">Now, to show how simple I think all this could be, here is a PATCH
          </pre>
        </blockquote>
        <pre wrap="">implementing what
        </pre>
        <blockquote type="cite">
          <pre wrap="">I think is the *minimal* API required to support DVB-S2.

Notes:

* same API structure, I just added some new enums and variables, nothing
          </pre>
        </blockquote>
        <pre wrap="">removed
        </pre>
        <blockquote type="cite">
          <pre wrap="">* no changes required to any existing drivers (v4l-dvb still compiles)
* no changes required to existing applications (just need to be
          </pre>
        </blockquote>
        <pre wrap="">recompiled)
        </pre>
        <blockquote type="cite">
          <pre wrap="">* no drivers, but I think the HVR4000 MFE patch could be easily adapted

I added the fe_caps2 enum because we're running out of bits in the
          </pre>
        </blockquote>
        <pre wrap="">capabilities bitfield.
        </pre>
        <blockquote type="cite">
          <pre wrap="">More elegant would be to have separate bitfields for FEC capabilities
          </pre>
        </blockquote>
        <pre wrap="">and modulation
        </pre>
        <blockquote type="cite">
          <pre wrap="">capabilities but that would require (easy) changes to (a lot of) drivers
          </pre>
        </blockquote>
        <pre wrap="">and applications.
        </pre>
        <blockquote type="cite">
          <pre wrap="">Why should we not merge something simple like this immediately? This
          </pre>
        </blockquote>
        <pre wrap="">could have been done
        </pre>
        <blockquote type="cite">
          <pre wrap="">years ago. If it takes several rounds of API upgrades to reach all the
          </pre>
        </blockquote>
        <pre wrap="">feature people want then
        </pre>
        <blockquote type="cite">
          <pre wrap="">so be it, but a long journey begins with one step.
          </pre>
        </blockquote>
        <pre wrap="">This will break binary compatibility with existing apps.  You're right
-- those apps will work with a recompile, but I believe that as a
whole, the linux-dvb kernel and userspace developers alike are looking
to avoid breaking binary compatibility.
        </pre>
      </blockquote>
      <pre wrap="">Michael,
thank you for your comment.

I understand, but I think binary compatibility *should* be broken in this case. It makes
everything else simpler.
      </pre>
    </blockquote>
    <pre wrap="">No way. Breaking binary compatibility is a no-go.

    </pre>
    <blockquote type="cite">
      <pre wrap="">I know that not breaking binary compatibility *can* be done (as in the HVR4000 SFE and
MFE patches) but at what cost?  The resulting code is very odd. Look at multiproto which 
bizarrely implements both the 3.2 and the 3.3 API and a compatibility layer as well, at huge cost
in terms of development time and complexity of understanding. The wrappers used in the MFE
patches are a neat and simple trick, but not something you would release in the kernel.
      </pre>
    </blockquote>
    <pre wrap="">The only way to support DVB-S2 in a reasonable way is adding a new API.
Multiproto does this.

    </pre>
    <blockquote type="cite">
      <pre wrap="">If you take the position the binary interface cannot *ever* change then you are severely
restricting the changes that can be made and you doom yourself to an API that is no longer
suited to the job. And the complexity kills. As we have seen, it makes the whole process grind to a
halt. 

Recompilation is not a big deal. All distros recompile every application for each release (in fact much more frequently -- updates too), so most users will never even notice.  It is much better to make the right, elegant changes to the API and require a recompilation. It's better for the application developers because they get a sane evolution of the API and can more easily add new features. Anyone who
really cannot recompile existing userspace binaries will also have plenty of other restrictions and
should not be trying to drop a new kernel into a fixed userspace.
      </pre>
    </blockquote>
    <pre wrap="">The linux distribution maintainers would kill you.
Applications must continue to run after a kernel update.

    </pre>
    <blockquote type="cite">
      <pre wrap="">I would be interested to hear your opinion on how we can move forward rapidly.
      </pre>
    </blockquote>
    <pre wrap="">Multiproto should be merged asap.
    </pre>
  </blockquote>
  <pre wrap=""><!---->

True. Sorry about the long delay, just got back after quite a long
journey. Will do so these following days.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a>
  </pre>
</blockquote>
</body>
</html>

--------------050003070002000609050908--


--===============1153022888==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1153022888==--
